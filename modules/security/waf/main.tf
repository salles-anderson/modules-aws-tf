data "aws_region" "current" {}

locals {
  tags = merge(
    {
      Project = var.project_name
    },
    var.tags,
  )

  metric_name = replace(var.name, "/[^A-Za-z0-9]/", "_")

  managed_common_rules = var.enable_aws_managed_common_rules ? [
    {
      name           = "AWSManagedRulesCommonRuleSet"
      vendor_name    = "AWS"
      priority       = var.aws_managed_common_priority
      excluded_rules = []
    }
  ] : []

  managed_rules = concat(
    local.managed_common_rules,
    var.managed_rule_groups,
  )
}

resource "aws_wafv2_web_acl" "this" {
  name        = var.name
  scope       = var.scope
  description = var.description

  default_action {
    dynamic "allow" {
      for_each = var.default_action == "allow" ? [1] : []
      content {}
    }

    dynamic "block" {
      for_each = var.default_action == "block" ? [1] : []
      content {}
    }
  }

  dynamic "rule" {
    for_each = local.managed_rules
    content {
      name     = rule.value.name
      priority = rule.value.priority

      override_action {
        none {}
      }

      statement {
        managed_rule_group_statement {
          name        = rule.value.name
          vendor_name = rule.value.vendor_name

          dynamic "rule_action_override" {
            for_each = lookup(rule.value, "excluded_rules", [])
            content {
              name = rule_action_override.value

              action_to_use {
                count {}
              }
            }
          }
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = var.cloudwatch_metrics_enabled
        metric_name                = replace(format("%s-%s", var.name, rule.value.name), "/[^A-Za-z0-9]/", "_")
        sampled_requests_enabled   = var.sampled_requests_enabled
      }
    }
  }

  dynamic "rule" {
    for_each = var.enable_rate_limit ? [1] : []
    content {
      name     = "rate-limit"
      priority = var.rate_priority

      action {
        dynamic "block" {
          for_each = var.rate_action == "block" ? [1] : []
          content {}
        }

        dynamic "count" {
          for_each = var.rate_action == "count" ? [1] : []
          content {}
        }
      }

      statement {
        rate_based_statement {
          limit              = var.rate_limit
          aggregate_key_type = var.rate_aggregate_key_type

          dynamic "forwarded_ip_config" {
            for_each = var.rate_aggregate_key_type == "FORWARDED_IP" ? [1] : []
            content {
              header_name       = var.rate_forwarded_ip_config.header_name
              fallback_behavior = var.rate_forwarded_ip_config.fallback_behavior
            }
          }
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = var.cloudwatch_metrics_enabled
        metric_name                = replace(format("%s-rate-limit", var.name), "/[^A-Za-z0-9]/", "_")
        sampled_requests_enabled   = var.sampled_requests_enabled
      }
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = var.cloudwatch_metrics_enabled
    metric_name                = local.metric_name
    sampled_requests_enabled   = var.sampled_requests_enabled
  }

  tags = merge(
    local.tags,
    {
      Name = var.name
    },
  )

  lifecycle {
    precondition {
      condition     = var.scope != "CLOUDFRONT" || data.aws_region.current.name == "us-east-1"
      error_message = "WAF com scope CLOUDFRONT deve ser criado na região us-east-1 (configure provider alias aws.us_east_1)."
    }

    precondition {
      condition     = var.scope != "CLOUDFRONT" || length(var.association_resource_arns) == 0
      error_message = "association_resource_arns só é suportado para scope REGIONAL."
    }
  }
}

resource "aws_wafv2_web_acl_association" "regional" {
  count = var.scope == "REGIONAL" ? length(var.association_resource_arns) : 0

  resource_arn = var.association_resource_arns[count.index]
  web_acl_arn  = aws_wafv2_web_acl.this.arn
}

resource "aws_wafv2_web_acl_logging_configuration" "this" {
  count = var.enable_logging && var.logging_destination_arn != null ? 1 : 0

  resource_arn            = aws_wafv2_web_acl.this.arn
  log_destination_configs = [var.logging_destination_arn]

  dynamic "redacted_fields" {
    for_each = [
      for f in var.redacted_fields : f
      if contains(["method", "query_string", "uri_path", "single_header"], lower(f.type))
    ]

    content {
      dynamic "method" {
        for_each = lower(redacted_fields.value.type) == "method" ? [1] : []
        content {}
      }

      dynamic "query_string" {
        for_each = lower(redacted_fields.value.type) == "query_string" ? [1] : []
        content {}
      }

      dynamic "single_header" {
        for_each = lower(redacted_fields.value.type) == "single_header" ? [1] : []
        content {
          name = redacted_fields.value.data
        }
      }

      dynamic "uri_path" {
        for_each = lower(redacted_fields.value.type) == "uri_path" ? [1] : []
        content {}
      }
    }
  }
}
