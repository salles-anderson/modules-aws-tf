# Exemplo básico - Lista de instâncias RDS
# Agenda stop/start para instâncias RDS específicas

module "rds_scheduler" {
  source = "../../../modules/cost-optimization/rds-scheduler"

  project_name = "dev-database"

  # Lista de identificadores RDS (instâncias ou clusters)
  rds_instances = [
    "dev-postgres",
    "dev-mysql"
  ]

  # Horário comercial: 8h-18h seg-sex (São Paulo)
  start_schedule    = "cron(0 8 ? * MON-FRI *)"
  stop_schedule     = "cron(0 18 ? * MON-FRI *)"
  schedule_timezone = "America/Sao_Paulo"

  tags = {
    Environment = "dev"
  }
}

output "lambda_function_arn" {
  value = module.rds_scheduler.lambda_function_arn
}

output "stop_schedule_arn" {
  value = module.rds_scheduler.stop_schedule_arn
}

output "start_schedule_arn" {
  value = module.rds_scheduler.start_schedule_arn
}
