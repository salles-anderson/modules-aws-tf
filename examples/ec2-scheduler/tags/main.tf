# Exemplo com descoberta por tags
# Encontra instâncias automaticamente usando tags

module "ec2_scheduler" {
  source = "../../../modules/cost-optimization/ec2-scheduler"

  project_name = "dev-auto-discovery"

  # Descobre instâncias com tag Environment=dev
  resource_tag_key   = "Environment"
  resource_tag_value = "dev"

  # Horário estendido: 7h-22h seg-sex
  start_schedule    = "cron(0 7 ? * MON-FRI *)"
  stop_schedule     = "cron(0 22 ? * MON-FRI *)"
  schedule_timezone = "America/Sao_Paulo"

  # Configuração Lambda
  lambda_timeout        = 120
  lambda_memory_size    = 256
  log_retention_in_days = 30

  tags = {
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}

output "lambda_function_name" {
  value = module.ec2_scheduler.lambda_function_name
}

output "log_group_name" {
  value = module.ec2_scheduler.log_group_name
}
