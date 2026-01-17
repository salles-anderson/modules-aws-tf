locals {

  lambda_source_dir = var.lambda_source_dir != null ? var.lambda_source_dir : abspath("${path.module}/src")
  lambda_in_vpc     = var.lambda_vpc_id != null && length(var.lambda_subnet_ids) > 0
  # lambda_uses_s3_package = var.lambda_package_s3_bucket != null && var.lambda_package_s3_key != null

  tags = merge(
    {
      Project   = var.project_name
      ManagedBy = "terraform"
    },
    var.tags,
  )
}

# data "archive_file" "lambda_package" {
#   count = local.lambda_uses_s3_package ? 0 : 1

#   type        = "zip"
#   source_dir  = local.lambda_source_dir
#   output_path = "${path.module}/lambda_payload.zip"
# }

data "archive_file" "lambda_package" {
  type        = "zip"
  source_dir  = local.lambda_source_dir
  output_path = "${path.module}/lambda_payload.zip"
}

data "aws_secretsmanager_secret" "api" {
  count = var.api_secret_name == null ? 0 : 1
  name  = var.api_secret_name
}

data "aws_iam_policy_document" "lambda_assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda" {
  name               = coalesce(var.lambda_role_name, format("%s-exec-role", var.lambda_function_name))
  assume_role_policy = data.aws_iam_policy_document.lambda_assume.json
  tags               = local.tags
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_vpc_access" {
  count      = local.lambda_in_vpc ? 1 : 0
  role       = aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_security_group" "lambda" {
  count = local.lambda_in_vpc && length(var.lambda_security_group_ids) == 0 ? 1 : 0

  name        = coalesce(var.lambda_security_group_name, "${var.lambda_function_name}-sg")
  description = "Default security group for the Lambda function"
  vpc_id      = var.lambda_vpc_id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = local.tags
}

resource "aws_lambda_function" "this" {
  function_name    = var.lambda_function_name
  description      = var.lambda_description
  role             = aws_iam_role.lambda.arn
  handler          = var.lambda_handler
  runtime          = var.lambda_runtime
  timeout          = var.lambda_timeout
  memory_size      = var.lambda_memory_size
  publish          = var.publish_lambda_version
  filename         = data.archive_file.lambda_package.output_path
  source_code_hash = data.archive_file.lambda_package.output_base64sha256

  # filename          = local.lambda_uses_s3_package ? null : data.archive_file.lambda_package[0].output_path
  # source_code_hash  = local.lambda_uses_s3_package ? var.lambda_source_code_hash : data.archive_file.lambda_package[0].output_base64sha256
  # s3_bucket         = local.lambda_uses_s3_package ? var.lambda_package_s3_bucket : null
  # s3_key            = local.lambda_uses_s3_package ? var.lambda_package_s3_key : null
  # s3_object_version = local.lambda_uses_s3_package ? var.lambda_package_s3_object_version : null
  environment {
    variables = merge(
      {
        API_URL = var.api_url
      },
      var.api_secret_name == null ? {} : { API_SECRET_ARN = data.aws_secretsmanager_secret.api[0].arn },
      var.additional_environment_variables,
      var.environment_variables,
    )
  }

  tags = local.tags



  dynamic "vpc_config" {
    for_each = local.lambda_in_vpc ? [1] : []

    content {
      subnet_ids         = var.lambda_subnet_ids
      security_group_ids = length(var.lambda_security_group_ids) > 0 ? var.lambda_security_group_ids : aws_security_group.lambda[*].id
    }
  }

}

resource "aws_cloudwatch_log_group" "lambda" {
  count = var.create_log_group ? 1 : 0

  name              = "/aws/lambda/${aws_lambda_function.this.function_name}"
  retention_in_days = var.log_retention_in_days
  kms_key_id        = var.cloudwatch_logs_kms_key_id
  tags              = local.tags
}
