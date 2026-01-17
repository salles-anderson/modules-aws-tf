# Exemplo básico - Lista de instâncias EC2
# Agenda stop/start para instâncias específicas

module "ec2_scheduler" {
  source = "../../../modules/cost-optimization/ec2-scheduler"

  project_name = "dev-environment"

  # Lista explícita de instâncias
  ec2_instance_ids = [
    "i-1234567890abcdef0",
    "i-0987654321fedcba0"
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
  value = module.ec2_scheduler.lambda_function_arn
}

output "stop_schedule_arn" {
  value = module.ec2_scheduler.stop_schedule_arn
}

output "start_schedule_arn" {
  value = module.ec2_scheduler.start_schedule_arn
}
