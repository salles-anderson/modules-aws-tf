# Exemplo com Presets ECS, RDS e Overview
# Usa dashboards pré-construídos para visualização rápida

module "dashboards" {
  source = "../../../modules/observability/cloudwatch-dashboards"

  project_name = "minha-app-prod"
  aws_region   = "us-east-1"

  # Dashboards ECS pré-construídos
  ecs_dashboards = {
    api = {
      cluster_name  = "prod-cluster"
      service_names = ["api-service", "worker-service"]
    }
  }

  # Dashboards RDS pré-construídos
  rds_dashboards = {
    primary = {
      db_instance_identifier = "prod-postgres"
    }
  }

  # Dashboards Lambda pré-construídos
  lambda_dashboards = {
    processors = {
      function_names = ["order-processor", "webhook-handler", "notification-sender"]
    }
  }

  # Dashboards ALB pré-construídos
  alb_dashboards = {
    main = {
      load_balancer_arn_suffix = "app/prod-alb/50dc6c495c0c9188"
      target_group_arn_suffix  = "targetgroup/api-tg/73e2d6bc24d8a067"
    }
  }

  # Dashboard de visão geral consolidado
  create_overview_dashboard = true

  overview_ecs_clusters = [
    {
      cluster_name = "prod-cluster"
      service_name = "api-service"
    },
    {
      cluster_name = "prod-cluster"
      service_name = "worker-service"
    }
  ]

  overview_rds_instances     = ["prod-postgres"]
  overview_lambda_functions  = ["order-processor", "webhook-handler"]
  overview_alb_arns          = ["app/prod-alb/50dc6c495c0c9188"]

  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

output "ecs_dashboard_arns" {
  value = module.dashboards.ecs_dashboard_arns
}

output "rds_dashboard_arns" {
  value = module.dashboards.rds_dashboard_arns
}

output "lambda_dashboard_arns" {
  value = module.dashboards.lambda_dashboard_arns
}

output "overview_dashboard_arn" {
  value = module.dashboards.overview_dashboard_arn
}
