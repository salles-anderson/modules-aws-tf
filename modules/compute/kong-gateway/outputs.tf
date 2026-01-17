# =============================================================================
# Kong Gateway Module - Outputs
# =============================================================================

# =============================================================================
# ECS Service
# =============================================================================

output "service_name" {
  description = "Nome do ECS Service do Kong."
  value       = aws_ecs_service.kong.name
}

output "service_arn" {
  description = "ARN do ECS Service do Kong."
  value       = aws_ecs_service.kong.id
}

output "task_definition_arn" {
  description = "ARN da Task Definition do Kong."
  value       = aws_ecs_task_definition.kong.arn
}

output "task_definition_family" {
  description = "Family da Task Definition do Kong."
  value       = aws_ecs_task_definition.kong.family
}

# =============================================================================
# Security Group
# =============================================================================

output "security_group_id" {
  description = "ID do Security Group do Kong."
  value       = aws_security_group.kong.id
}

output "security_group_arn" {
  description = "ARN do Security Group do Kong."
  value       = aws_security_group.kong.arn
}

# =============================================================================
# ALB Integration
# =============================================================================

output "target_group_arn" {
  description = "ARN do Target Group do Kong."
  value       = aws_lb_target_group.kong.arn
}

output "target_group_name" {
  description = "Nome do Target Group do Kong."
  value       = aws_lb_target_group.kong.name
}

output "listener_rule_arn" {
  description = "ARN da Listener Rule do Kong."
  value       = aws_lb_listener_rule.kong.arn
}

# =============================================================================
# Logging
# =============================================================================

output "log_group_name" {
  description = "Nome do CloudWatch Log Group do Kong."
  value       = aws_cloudwatch_log_group.kong.name
}

output "log_group_arn" {
  description = "ARN do CloudWatch Log Group do Kong."
  value       = aws_cloudwatch_log_group.kong.arn
}

# =============================================================================
# Endpoints
# =============================================================================

output "proxy_port" {
  description = "Porta do proxy Kong."
  value       = var.kong_proxy_port
}

output "admin_port" {
  description = "Porta da Admin API do Kong."
  value       = var.kong_admin_port
}

output "admin_endpoint" {
  description = "Endpoint interno da Admin API do Kong (acessível apenas via ECS Exec ou rede interna)."
  value       = "http://localhost:${var.kong_admin_port}"
}

# =============================================================================
# Backend Configuration
# =============================================================================

output "backend_url" {
  description = "URL configurada para o backend."
  value       = "${var.backend_protocol}://${var.backend_host}:${var.backend_port}${var.backend_path_prefix}"
}

# =============================================================================
# Auto Scaling
# =============================================================================

output "autoscaling_enabled" {
  description = "Indica se Auto Scaling está habilitado."
  value       = var.enable_autoscaling
}

output "autoscaling_target_id" {
  description = "ID do Auto Scaling Target (se habilitado)."
  value       = var.enable_autoscaling ? aws_appautoscaling_target.kong[0].id : null
}

# =============================================================================
# Kong Configuration
# =============================================================================

output "declarative_config" {
  description = "Configuração declarativa gerada para o Kong (YAML)."
  value       = local.kong_declarative_config
  sensitive   = true
}
