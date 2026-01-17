locals {
  tags = merge(
    {
      Project = var.project_name
    },
    var.tags,
  )

  lambda_function_name = coalesce(var.lambda_function_name, "${var.project_name}-rds-scheduler")

  stop_input = jsonencode({
    action    = "stop"
    instances = var.rds_instances
    tag_key   = var.resource_tag_key
    tag_value = var.resource_tag_value
  })

  start_input = jsonencode({
    action    = "start"
    instances = var.rds_instances
    tag_key   = var.resource_tag_key
    tag_value = var.resource_tag_value
  })
}

# =============================================================================
# Lambda Package
# =============================================================================

data "archive_file" "lambda_package" {
  type        = "zip"
  source_dir  = "${path.module}/lambda"
  output_path = "${path.module}/lambda_package.zip"
}

# =============================================================================
# IAM Role for Lambda
# =============================================================================

data "aws_iam_policy_document" "lambda_assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "lambda_rds" {
  statement {
    sid = "RDSOperations"
    actions = [
      "rds:DescribeDBInstances",
      "rds:StartDBInstance",
      "rds:StopDBInstance",
      "rds:ListTagsForResource",
    ]
    resources = ["*"]
  }

  statement {
    sid = "CloudWatchLogs"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = ["arn:aws:logs:*:*:*"]
  }
}

resource "aws_iam_role" "lambda" {
  name               = "${local.lambda_function_name}-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume.json
  tags               = local.tags
}

resource "aws_iam_role_policy" "lambda_rds" {
  name   = "rds-scheduler-policy"
  role   = aws_iam_role.lambda.id
  policy = data.aws_iam_policy_document.lambda_rds.json
}

# =============================================================================
# Lambda Function
# =============================================================================

resource "aws_lambda_function" "this" {
  function_name    = local.lambda_function_name
  description      = "Lambda para stop/start agendado de instâncias RDS"
  role             = aws_iam_role.lambda.arn
  handler          = "handler.lambda_handler"
  runtime          = "python3.12"
  timeout          = var.lambda_timeout
  memory_size      = var.lambda_memory_size
  filename         = data.archive_file.lambda_package.output_path
  source_code_hash = data.archive_file.lambda_package.output_base64sha256

  environment {
    variables = {
      DEFAULT_ACTION = "stop"
      TAG_KEY        = coalesce(var.resource_tag_key, "")
      TAG_VALUE      = coalesce(var.resource_tag_value, "")
    }
  }

  tags = local.tags
}

resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${local.lambda_function_name}"
  retention_in_days = var.log_retention_in_days
  tags              = local.tags
}

# =============================================================================
# IAM Role for EventBridge Scheduler
# =============================================================================

data "aws_iam_policy_document" "scheduler_assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["scheduler.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "scheduler_invoke" {
  statement {
    actions   = ["lambda:InvokeFunction"]
    resources = [aws_lambda_function.this.arn, "${aws_lambda_function.this.arn}:*"]
  }
}

resource "aws_iam_role" "scheduler" {
  name               = "${local.lambda_function_name}-scheduler-role"
  assume_role_policy = data.aws_iam_policy_document.scheduler_assume.json
  tags               = local.tags
}

resource "aws_iam_role_policy" "scheduler_invoke" {
  role   = aws_iam_role.scheduler.id
  policy = data.aws_iam_policy_document.scheduler_invoke.json
}

# =============================================================================
# EventBridge Scheduler - Stop Schedule
# =============================================================================

resource "aws_scheduler_schedule" "stop" {
  name        = "${var.project_name}-rds-stop"
  description = "Para instâncias RDS fora do horário comercial"
  state       = var.enable_schedule ? "ENABLED" : "DISABLED"

  schedule_expression          = var.stop_schedule
  schedule_expression_timezone = var.schedule_timezone

  flexible_time_window {
    mode = "OFF"
  }

  target {
    arn      = aws_lambda_function.this.arn
    role_arn = aws_iam_role.scheduler.arn
    input    = local.stop_input

    retry_policy {
      maximum_event_age_in_seconds = 3600
      maximum_retry_attempts       = 3
    }
  }
}

resource "aws_lambda_permission" "scheduler_stop" {
  statement_id  = "AllowSchedulerStop"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.function_name
  principal     = "scheduler.amazonaws.com"
  source_arn    = aws_scheduler_schedule.stop.arn
}

# =============================================================================
# EventBridge Scheduler - Start Schedule
# =============================================================================

resource "aws_scheduler_schedule" "start" {
  name        = "${var.project_name}-rds-start"
  description = "Inicia instâncias RDS no início do horário comercial"
  state       = var.enable_schedule ? "ENABLED" : "DISABLED"

  schedule_expression          = var.start_schedule
  schedule_expression_timezone = var.schedule_timezone

  flexible_time_window {
    mode = "OFF"
  }

  target {
    arn      = aws_lambda_function.this.arn
    role_arn = aws_iam_role.scheduler.arn
    input    = local.start_input

    retry_policy {
      maximum_event_age_in_seconds = 3600
      maximum_retry_attempts       = 3
    }
  }
}

resource "aws_lambda_permission" "scheduler_start" {
  statement_id  = "AllowSchedulerStart"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.function_name
  principal     = "scheduler.amazonaws.com"
  source_arn    = aws_scheduler_schedule.start.arn
}

# =============================================================================
# EventBridge Scheduler - Re-Stop (Workaround para auto-start de 7 dias)
# =============================================================================

resource "aws_scheduler_schedule" "restop" {
  count = var.enable_restop_schedule ? 1 : 0

  name        = "${var.project_name}-rds-restop"
  description = "Re-para instâncias RDS que foram auto-iniciadas após 7 dias"
  state       = var.enable_schedule ? "ENABLED" : "DISABLED"

  schedule_expression          = var.restop_schedule
  schedule_expression_timezone = var.schedule_timezone

  flexible_time_window {
    mode = "OFF"
  }

  target {
    arn      = aws_lambda_function.this.arn
    role_arn = aws_iam_role.scheduler.arn
    input    = local.stop_input

    retry_policy {
      maximum_event_age_in_seconds = 3600
      maximum_retry_attempts       = 3
    }
  }
}

resource "aws_lambda_permission" "scheduler_restop" {
  count = var.enable_restop_schedule ? 1 : 0

  statement_id  = "AllowSchedulerRestop"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.function_name
  principal     = "scheduler.amazonaws.com"
  source_arn    = aws_scheduler_schedule.restop[0].arn
}
