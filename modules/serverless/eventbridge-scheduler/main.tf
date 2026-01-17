locals {

  scheduler_role_name = substr("${var.lambda_function_name}-scheduler-role", 0, 64)

  tags = merge(
    {
      Project   = var.project_name
      ManagedBy = "terraform"
    },
    var.tags,
  )
}

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
    resources = [var.lambda_function_arn, "${var.lambda_function_arn}:*"]
  }
}

resource "aws_iam_role" "scheduler" {
  name               = coalesce(var.scheduler_role_name, "role-${var.schedule_name}")
  assume_role_policy = data.aws_iam_policy_document.scheduler_assume.json
  tags               = local.tags
}

resource "aws_iam_role_policy" "scheduler_invoke" {
  role   = aws_iam_role.scheduler.id
  policy = data.aws_iam_policy_document.scheduler_invoke.json
}

resource "aws_scheduler_schedule" "this" {
  name        = var.schedule_name
  description = var.schedule_description
  state       = var.enable_schedule ? "ENABLED" : "DISABLED"

  schedule_expression          = var.schedule_expression
  schedule_expression_timezone = var.schedule_timezone

  flexible_time_window {
    mode = "OFF"
  }

  target {
    arn      = var.lambda_function_arn
    role_arn = aws_iam_role.scheduler.arn
    input    = var.target_input

    dynamic "retry_policy" {
      for_each = var.schedule_retry_attempts == null && var.schedule_event_age_in_seconds == null ? [] : [1]

      content {
        maximum_event_age_in_seconds = var.schedule_event_age_in_seconds
        maximum_retry_attempts       = var.schedule_retry_attempts
      }
    }
  }

  kms_key_arn = var.schedule_kms_key_arn
  group_name  = var.schedule_group_name

}

resource "aws_lambda_permission" "scheduler" {
  statement_id  = "AllowSchedulerInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "scheduler.amazonaws.com"
  source_arn    = aws_scheduler_schedule.this.arn
}

