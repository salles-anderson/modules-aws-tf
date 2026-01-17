# Exemplo com Presets ECS, RDS e Lambda
# Usa alarmes pré-configurados para monitoramento rápido

module "alarms" {
  source = "../../../modules/observability/cloudwatch-alarms"

  project_name = "minha-app-prod"

  # Usa tópico SNS existente
  sns_topic_arns = ["arn:aws:sns:us-east-1:123456789012:alerts-prod"]

  # Presets para serviços ECS
  ecs_service_alarms = {
    api = {
      cluster_name = "prod-cluster"
      service_name = "api-service"
      # Valores padrão: CPU > 80%, Memory > 80%
    }
    worker = {
      cluster_name              = "prod-cluster"
      service_name              = "worker-service"
      cpu_threshold             = 90
      cpu_evaluation_periods    = 5
      memory_threshold          = 85
      memory_evaluation_periods = 3
      tags = {
        Component = "worker"
      }
    }
  }

  # Presets para instâncias RDS
  rds_alarms = {
    primary = {
      db_instance_identifier = "prod-postgres"
      cpu_threshold          = 85
      storage_threshold_bytes = 10737418240 # 10GB
      connections_threshold   = 100
      tags = {
        Component = "database"
      }
    }
  }

  # Presets para funções Lambda
  lambda_alarms = {
    processor = {
      function_name         = "order-processor"
      errors_threshold      = 5
      duration_threshold_ms = 10000
      throttles_threshold   = 1
    }
    webhook = {
      function_name    = "webhook-handler"
      errors_threshold = 1
      tags = {
        Component = "integration"
      }
    }
  }

  # Presets para ALB
  alb_alarms = {
    main = {
      load_balancer_arn_suffix = "app/prod-alb/50dc6c495c0c9188"
      target_group_arn_suffix  = "targetgroup/api-tg/73e2d6bc24d8a067"
      error_5xx_threshold      = 10
      unhealthy_threshold      = 1
      latency_threshold_seconds = 2.0
    }
  }

  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

output "ecs_alarm_arns" {
  value = module.alarms.ecs_alarm_arns
}

output "rds_alarm_arns" {
  value = module.alarms.rds_alarm_arns
}

output "lambda_alarm_arns" {
  value = module.alarms.lambda_alarm_arns
}

output "alb_alarm_arns" {
  value = module.alarms.alb_alarm_arns
}
