# =============================================================================
# SNS Outputs
# =============================================================================

output "sns_topic_arn" {
  description = "ARN do tópico SNS criado pelo módulo."
  value       = var.create_sns_topic ? aws_sns_topic.this[0].arn : null
}

output "sns_topic_name" {
  description = "Nome do tópico SNS criado pelo módulo."
  value       = var.create_sns_topic ? aws_sns_topic.this[0].name : null
}

# =============================================================================
# Custom Alarms Outputs
# =============================================================================

output "metric_alarm_arns" {
  description = "Mapa de ARNs dos alarmes de métricas customizados."
  value       = { for k, v in aws_cloudwatch_metric_alarm.custom : k => v.arn }
}

output "metric_alarm_names" {
  description = "Mapa de nomes dos alarmes de métricas customizados."
  value       = { for k, v in aws_cloudwatch_metric_alarm.custom : k => v.alarm_name }
}

output "composite_alarm_arns" {
  description = "Mapa de ARNs dos alarmes compostos."
  value       = { for k, v in aws_cloudwatch_composite_alarm.this : k => v.arn }
}

output "composite_alarm_names" {
  description = "Mapa de nomes dos alarmes compostos."
  value       = { for k, v in aws_cloudwatch_composite_alarm.this : k => v.alarm_name }
}

# =============================================================================
# ECS Preset Alarms Outputs
# =============================================================================

output "ecs_cpu_alarm_arns" {
  description = "Mapa de ARNs dos alarmes de CPU do ECS."
  value       = { for k, v in aws_cloudwatch_metric_alarm.ecs_cpu : k => v.arn }
}

output "ecs_memory_alarm_arns" {
  description = "Mapa de ARNs dos alarmes de memória do ECS."
  value       = { for k, v in aws_cloudwatch_metric_alarm.ecs_memory : k => v.arn }
}

# =============================================================================
# RDS Preset Alarms Outputs
# =============================================================================

output "rds_cpu_alarm_arns" {
  description = "Mapa de ARNs dos alarmes de CPU do RDS."
  value       = { for k, v in aws_cloudwatch_metric_alarm.rds_cpu : k => v.arn }
}

output "rds_memory_alarm_arns" {
  description = "Mapa de ARNs dos alarmes de memória do RDS."
  value       = { for k, v in aws_cloudwatch_metric_alarm.rds_memory : k => v.arn }
}

output "rds_storage_alarm_arns" {
  description = "Mapa de ARNs dos alarmes de storage do RDS."
  value       = { for k, v in aws_cloudwatch_metric_alarm.rds_storage : k => v.arn }
}

output "rds_connections_alarm_arns" {
  description = "Mapa de ARNs dos alarmes de conexões do RDS."
  value       = { for k, v in aws_cloudwatch_metric_alarm.rds_connections : k => v.arn }
}

# =============================================================================
# Lambda Preset Alarms Outputs
# =============================================================================

output "lambda_errors_alarm_arns" {
  description = "Mapa de ARNs dos alarmes de erros do Lambda."
  value       = { for k, v in aws_cloudwatch_metric_alarm.lambda_errors : k => v.arn }
}

output "lambda_duration_alarm_arns" {
  description = "Mapa de ARNs dos alarmes de duração do Lambda."
  value       = { for k, v in aws_cloudwatch_metric_alarm.lambda_duration : k => v.arn }
}

output "lambda_throttles_alarm_arns" {
  description = "Mapa de ARNs dos alarmes de throttling do Lambda."
  value       = { for k, v in aws_cloudwatch_metric_alarm.lambda_throttles : k => v.arn }
}

# =============================================================================
# ALB Preset Alarms Outputs
# =============================================================================

output "alb_5xx_alarm_arns" {
  description = "Mapa de ARNs dos alarmes de 5XX do ALB."
  value       = { for k, v in aws_cloudwatch_metric_alarm.alb_5xx : k => v.arn }
}

output "alb_unhealthy_alarm_arns" {
  description = "Mapa de ARNs dos alarmes de hosts não saudáveis do ALB."
  value       = { for k, v in aws_cloudwatch_metric_alarm.alb_unhealthy : k => v.arn }
}

output "alb_latency_alarm_arns" {
  description = "Mapa de ARNs dos alarmes de latência do ALB."
  value       = { for k, v in aws_cloudwatch_metric_alarm.alb_latency : k => v.arn }
}

# =============================================================================
# All Alarms (Aggregated)
# =============================================================================

output "all_alarm_arns" {
  description = "Lista de todos os ARNs de alarmes criados pelo módulo."
  value = concat(
    values({ for k, v in aws_cloudwatch_metric_alarm.custom : k => v.arn }),
    values({ for k, v in aws_cloudwatch_metric_alarm.ecs_cpu : k => v.arn }),
    values({ for k, v in aws_cloudwatch_metric_alarm.ecs_memory : k => v.arn }),
    values({ for k, v in aws_cloudwatch_metric_alarm.rds_cpu : k => v.arn }),
    values({ for k, v in aws_cloudwatch_metric_alarm.rds_memory : k => v.arn }),
    values({ for k, v in aws_cloudwatch_metric_alarm.rds_storage : k => v.arn }),
    values({ for k, v in aws_cloudwatch_metric_alarm.rds_connections : k => v.arn }),
    values({ for k, v in aws_cloudwatch_metric_alarm.lambda_errors : k => v.arn }),
    values({ for k, v in aws_cloudwatch_metric_alarm.lambda_duration : k => v.arn }),
    values({ for k, v in aws_cloudwatch_metric_alarm.lambda_throttles : k => v.arn }),
    values({ for k, v in aws_cloudwatch_metric_alarm.alb_5xx : k => v.arn }),
    values({ for k, v in aws_cloudwatch_metric_alarm.alb_unhealthy : k => v.arn }),
    values({ for k, v in aws_cloudwatch_metric_alarm.alb_latency : k => v.arn }),
  )
}
