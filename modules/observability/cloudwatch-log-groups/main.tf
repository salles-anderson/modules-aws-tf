locals {
  tags = merge(
    {
      Project = var.project_name
    },
    var.tags,
  )
}

resource "aws_cloudwatch_log_group" "this" {
  for_each = var.log_groups

  name              = each.value.name
  retention_in_days = lookup(each.value, "retention_in_days", var.default_retention_in_days)
  kms_key_id        = lookup(each.value, "kms_key_id", null)
  log_group_class   = lookup(each.value, "log_group_class", "STANDARD")
  skip_destroy      = lookup(each.value, "skip_destroy", false)

  tags = merge(
    local.tags,
    lookup(each.value, "tags", {}),
    {
      Name = each.value.name
    },
  )
}

resource "aws_cloudwatch_log_subscription_filter" "this" {
  for_each = var.subscription_filters

  name            = each.key
  log_group_name  = aws_cloudwatch_log_group.this[each.value.log_group_key].name
  filter_pattern  = lookup(each.value, "filter_pattern", "")
  destination_arn = each.value.destination_arn
  role_arn        = lookup(each.value, "role_arn", null)
  distribution    = lookup(each.value, "distribution", null)

  depends_on = [aws_cloudwatch_log_group.this]
}

resource "aws_cloudwatch_log_metric_filter" "this" {
  for_each = var.metric_filters

  name           = each.key
  log_group_name = aws_cloudwatch_log_group.this[each.value.log_group_key].name
  pattern        = each.value.pattern

  metric_transformation {
    name          = each.value.metric_name
    namespace     = each.value.metric_namespace
    value         = lookup(each.value, "metric_value", "1")
    default_value = lookup(each.value, "default_value", null)
    unit          = lookup(each.value, "unit", null)
    dimensions    = lookup(each.value, "dimensions", null)
  }

  depends_on = [aws_cloudwatch_log_group.this]
}
