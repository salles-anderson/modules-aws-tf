output "lambda_function_arn" {
  description = "ARN da função Lambda do scheduler."
  value       = aws_lambda_function.this.arn
}

output "lambda_function_name" {
  description = "Nome da função Lambda do scheduler."
  value       = aws_lambda_function.this.function_name
}

output "lambda_role_arn" {
  description = "ARN da role IAM da Lambda."
  value       = aws_iam_role.lambda.arn
}

output "stop_schedule_arn" {
  description = "ARN do schedule de stop."
  value       = aws_scheduler_schedule.stop.arn
}

output "start_schedule_arn" {
  description = "ARN do schedule de start."
  value       = aws_scheduler_schedule.start.arn
}

output "restop_schedule_arn" {
  description = "ARN do schedule de re-stop (workaround 7 dias), ou null se desabilitado."
  value       = var.enable_restop_schedule ? aws_scheduler_schedule.restop[0].arn : null
}

output "log_group_name" {
  description = "Nome do CloudWatch Log Group da Lambda."
  value       = aws_cloudwatch_log_group.lambda.name
}
