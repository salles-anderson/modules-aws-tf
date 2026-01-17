# Exemplo completo - Log Groups com KMS, Metric Filters e Subscriptions
# Demonstra todas as funcionalidades do módulo

# Referência a KMS Key existente
data "aws_kms_key" "logs" {
  key_id = "alias/cloudwatch-logs"
}

# Referência a Lambda de processamento existente
data "aws_lambda_function" "log_processor" {
  function_name = "log-processor"
}

module "log_groups" {
  source = "../../../modules/observability/cloudwatch-log-groups"

  project_name              = "minha-app-prod"
  default_retention_in_days = 90

  log_groups = {
    app = {
      name            = "/ecs/minha-app-prod"
      kms_key_id      = data.aws_kms_key.logs.arn
      log_group_class = "STANDARD"
      skip_destroy    = true
      tags = {
        Component = "api"
      }
    }
    worker = {
      name              = "/ecs/minha-app-prod-worker"
      retention_in_days = 30
      kms_key_id        = data.aws_kms_key.logs.arn
      tags = {
        Component = "worker"
      }
    }
    audit = {
      name              = "/audit/minha-app-prod"
      retention_in_days = 365
      kms_key_id        = data.aws_kms_key.logs.arn
      skip_destroy      = true
      tags = {
        Component  = "audit"
        Compliance = "required"
      }
    }
  }

  # Extrai métricas dos logs
  metric_filters = {
    app_errors = {
      log_group_key    = "app"
      pattern          = "[timestamp, level=\"ERROR\", ...]"
      metric_name      = "ErrorCount"
      metric_namespace = "MinhaApp/Prod"
      metric_value     = "1"
      default_value    = 0
      unit             = "Count"
    }
    app_latency = {
      log_group_key    = "app"
      pattern          = "[timestamp, level, message, latency]"
      metric_name      = "RequestLatency"
      metric_namespace = "MinhaApp/Prod"
      metric_value     = "$latency"
      unit             = "Milliseconds"
      dimensions = {
        Service = "api"
      }
    }
    worker_failures = {
      log_group_key    = "worker"
      pattern          = "?ERROR ?FAILED"
      metric_name      = "WorkerFailures"
      metric_namespace = "MinhaApp/Prod"
      metric_value     = "1"
      unit             = "Count"
    }
  }

  # Streaming de logs para Lambda
  subscription_filters = {
    app_to_processor = {
      log_group_key   = "app"
      destination_arn = data.aws_lambda_function.log_processor.arn
      filter_pattern  = "{ $.level = \"ERROR\" }"
      distribution    = "ByLogStream"
    }
    audit_to_processor = {
      log_group_key   = "audit"
      destination_arn = data.aws_lambda_function.log_processor.arn
      filter_pattern  = ""
      distribution    = "Random"
    }
  }

  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

output "log_group_arns" {
  value = module.log_groups.log_group_arns
}

output "metric_filter_ids" {
  value = module.log_groups.metric_filter_ids
}

output "subscription_filter_ids" {
  value = module.log_groups.subscription_filter_ids
}
