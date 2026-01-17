output "custom_dashboard_arns" {
  description = "Mapa de ARNs dos dashboards customizados."
  value       = { for k, v in aws_cloudwatch_dashboard.custom : k => v.dashboard_arn }
}

output "ecs_dashboard_arns" {
  description = "Mapa de ARNs dos dashboards ECS."
  value       = { for k, v in aws_cloudwatch_dashboard.ecs : k => v.dashboard_arn }
}

output "rds_dashboard_arns" {
  description = "Mapa de ARNs dos dashboards RDS."
  value       = { for k, v in aws_cloudwatch_dashboard.rds : k => v.dashboard_arn }
}

output "lambda_dashboard_arns" {
  description = "Mapa de ARNs dos dashboards Lambda."
  value       = { for k, v in aws_cloudwatch_dashboard.lambda : k => v.dashboard_arn }
}

output "alb_dashboard_arns" {
  description = "Mapa de ARNs dos dashboards ALB."
  value       = { for k, v in aws_cloudwatch_dashboard.alb : k => v.dashboard_arn }
}

output "overview_dashboard_arn" {
  description = "ARN do dashboard de visão geral."
  value       = var.create_overview_dashboard ? aws_cloudwatch_dashboard.overview[0].dashboard_arn : null
}

output "all_dashboard_names" {
  description = "Lista de todos os nomes de dashboards criados."
  value = concat(
    keys(aws_cloudwatch_dashboard.custom),
    keys(aws_cloudwatch_dashboard.ecs),
    keys(aws_cloudwatch_dashboard.rds),
    keys(aws_cloudwatch_dashboard.lambda),
    keys(aws_cloudwatch_dashboard.alb),
    var.create_overview_dashboard ? [aws_cloudwatch_dashboard.overview[0].dashboard_name] : []
  )
}
