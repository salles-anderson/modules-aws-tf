output "service_name" {
  description = "O nome do serviço ECS criado."
  value       = aws_ecs_service.this.name
}

output "task_definition_arn" {
  description = "O ARN completo da definição de tarefa criada."
  value       = aws_ecs_task_definition.this.arn
}

output "task_definition_family" {
  description = "A família da definição de tarefa criada."
  value       = aws_ecs_task_definition.this.family
}

output "enable_execute_command" {
  description = "Habilita conexão no container via aws cli."
  value       = var.enable_execute_command
}
