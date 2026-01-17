locals {
  tags = merge(
    {
      Project = var.project_name
    },
    var.tags,
  )

  sns_topic_arns = var.create_sns_topic ? concat([aws_sns_topic.this[0].arn], var.sns_topic_arns) : var.sns_topic_arns
}

resource "aws_sns_topic" "this" {
  count = var.create_sns_topic ? 1 : 0

  name              = coalesce(var.sns_topic_name, "${var.project_name}-alarms")
  kms_master_key_id = var.sns_kms_key_id

  tags = merge(
    local.tags,
    {
      Name = coalesce(var.sns_topic_name, "${var.project_name}-alarms")
    },
  )
}

resource "aws_sns_topic_subscription" "this" {
  for_each = var.create_sns_topic ? var.sns_subscriptions : {}

  topic_arn = aws_sns_topic.this[0].arn
  protocol  = each.value.protocol
  endpoint  = each.value.endpoint
}

resource "aws_cloudwatch_metric_alarm" "custom" {
  for_each = var.metric_alarms

  alarm_name          = each.key
  alarm_description   = lookup(each.value, "description", null)
  comparison_operator = each.value.comparison_operator
  evaluation_periods  = each.value.evaluation_periods
  metric_name         = lookup(each.value, "metric_name", null)
  namespace           = lookup(each.value, "namespace", null)
  period              = lookup(each.value, "period", null)
  statistic           = lookup(each.value, "statistic", null)
  extended_statistic  = lookup(each.value, "extended_statistic", null)
  threshold           = lookup(each.value, "threshold", null)
  threshold_metric_id = lookup(each.value, "threshold_metric_id", null)

  dimensions          = lookup(each.value, "dimensions", null)
  unit                = lookup(each.value, "unit", null)
  datapoints_to_alarm = lookup(each.value, "datapoints_to_alarm", null)

  treat_missing_data = lookup(each.value, "treat_missing_data", "missing")
  actions_enabled    = lookup(each.value, "actions_enabled", true)

  alarm_actions             = lookup(each.value, "alarm_actions", local.sns_topic_arns)
  ok_actions                = lookup(each.value, "ok_actions", [])
  insufficient_data_actions = lookup(each.value, "insufficient_data_actions", [])

  dynamic "metric_query" {
    for_each = lookup(each.value, "metric_queries", [])

    content {
      id          = metric_query.value.id
      expression  = lookup(metric_query.value, "expression", null)
      label       = lookup(metric_query.value, "label", null)
      return_data = lookup(metric_query.value, "return_data", null)
      period      = lookup(metric_query.value, "period", null)

      dynamic "metric" {
        for_each = lookup(metric_query.value, "metric", null) != null ? [metric_query.value.metric] : []

        content {
          metric_name = metric.value.metric_name
          namespace   = metric.value.namespace
          period      = metric.value.period
          stat        = metric.value.stat
          unit        = lookup(metric.value, "unit", null)
          dimensions  = lookup(metric.value, "dimensions", null)
        }
      }
    }
  }

  tags = merge(
    local.tags,
    lookup(each.value, "tags", {}),
  )
}

resource "aws_cloudwatch_composite_alarm" "this" {
  for_each = var.composite_alarms

  alarm_name        = each.key
  alarm_description = lookup(each.value, "description", null)
  alarm_rule        = each.value.alarm_rule
  actions_enabled   = lookup(each.value, "actions_enabled", true)

  alarm_actions             = lookup(each.value, "alarm_actions", local.sns_topic_arns)
  ok_actions                = lookup(each.value, "ok_actions", [])
  insufficient_data_actions = lookup(each.value, "insufficient_data_actions", [])

  dynamic "actions_suppressor" {
    for_each = lookup(each.value, "actions_suppressor", null) != null ? [1] : []

    content {
      alarm            = each.value.actions_suppressor
      wait_period      = lookup(each.value, "actions_suppressor_wait_period", 0)
      extension_period = lookup(each.value, "actions_suppressor_extension_period", 0)
    }
  }

  tags = merge(
    local.tags,
    lookup(each.value, "tags", {}),
  )

  depends_on = [
    aws_cloudwatch_metric_alarm.custom,
    aws_cloudwatch_metric_alarm.ecs_cpu,
    aws_cloudwatch_metric_alarm.ecs_memory,
    aws_cloudwatch_metric_alarm.rds_cpu,
    aws_cloudwatch_metric_alarm.rds_memory,
    aws_cloudwatch_metric_alarm.rds_storage,
    aws_cloudwatch_metric_alarm.rds_connections,
    aws_cloudwatch_metric_alarm.lambda_errors,
    aws_cloudwatch_metric_alarm.lambda_duration,
    aws_cloudwatch_metric_alarm.lambda_throttles,
    aws_cloudwatch_metric_alarm.alb_5xx,
    aws_cloudwatch_metric_alarm.alb_unhealthy,
    aws_cloudwatch_metric_alarm.alb_latency,
  ]
}
