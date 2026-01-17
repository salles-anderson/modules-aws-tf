# Exemplo básico - Lista de clusters DocumentDB
# Agenda stop/start para clusters DocumentDB específicos

module "documentdb_scheduler" {
  source = "../../../modules/cost-optimization/documentdb-scheduler"

  project_name = "dev-docdb"

  # Lista de identificadores de clusters DocumentDB
  documentdb_clusters = [
    "dev-docdb-cluster"
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
  value = module.documentdb_scheduler.lambda_function_arn
}

output "stop_schedule_arn" {
  value = module.documentdb_scheduler.stop_schedule_arn
}

output "start_schedule_arn" {
  value = module.documentdb_scheduler.start_schedule_arn
}
