# Exemplo básico - Log Groups simples
# Cria log groups com retenção configurável

module "log_groups" {
  source = "../../../modules/observability/cloudwatch-log-groups"

  project_name = "minha-app"

  # Retenção padrão para todos os log groups
  default_retention_in_days = 30

  log_groups = {
    app = {
      name = "/ecs/minha-app"
    }
    worker = {
      name              = "/ecs/minha-app-worker"
      retention_in_days = 14 # Override do padrão
    }
    lambda = {
      name              = "/aws/lambda/minha-app-processor"
      retention_in_days = 7
    }
  }

  tags = {
    Environment = "production"
  }
}

output "log_group_arns" {
  value = module.log_groups.log_group_arns
}

output "log_group_names" {
  value = module.log_groups.log_group_names
}
