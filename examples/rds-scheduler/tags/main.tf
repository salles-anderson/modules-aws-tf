# Exemplo com descoberta por tags e re-stop
# Encontra instâncias RDS automaticamente e contorna auto-start de 7 dias

module "rds_scheduler" {
  source = "../../../modules/cost-optimization/rds-scheduler"

  project_name = "homolog-database"

  # Descobre instâncias com tag Environment=homolog
  resource_tag_key   = "Environment"
  resource_tag_value = "homolog"

  # Horário comercial: 8h-20h seg-sex
  start_schedule    = "cron(0 8 ? * MON-FRI *)"
  stop_schedule     = "cron(0 20 ? * MON-FRI *)"
  schedule_timezone = "America/Sao_Paulo"

  # Habilita re-stop para contornar auto-start após 7 dias
  # RDS/Aurora auto-inicia após 7 dias parado
  # Este schedule verifica e para novamente se necessário
  enable_restop_schedule = true
  restop_schedule        = "cron(0 21 ? * MON-FRI *)"

  # Configuração Lambda
  lambda_timeout        = 120
  lambda_memory_size    = 256
  log_retention_in_days = 30

  tags = {
    Environment = "homolog"
    ManagedBy   = "terraform"
  }
}

output "lambda_function_name" {
  value = module.rds_scheduler.lambda_function_name
}

output "log_group_name" {
  value = module.rds_scheduler.log_group_name
}

output "restop_schedule_arn" {
  description = "ARN do schedule de re-stop (workaround 7 dias)"
  value       = module.rds_scheduler.restop_schedule_arn
}
