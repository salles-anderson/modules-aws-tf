output "log_group_arns" {
  description = "Mapa de ARNs dos log groups criados."
  value       = { for k, v in aws_cloudwatch_log_group.this : k => v.arn }
}

output "log_group_names" {
  description = "Mapa de nomes dos log groups criados."
  value       = { for k, v in aws_cloudwatch_log_group.this : k => v.name }
}

output "subscription_filter_names" {
  description = "Lista de nomes dos filtros de assinatura criados."
  value       = [for k, v in aws_cloudwatch_log_subscription_filter.this : v.name]
}

output "metric_filter_names" {
  description = "Lista de nomes dos filtros de métricas criados."
  value       = [for k, v in aws_cloudwatch_log_metric_filter.this : v.name]
}
