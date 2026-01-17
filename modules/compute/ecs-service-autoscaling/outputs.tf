output "autoscaling_target_arn" {
  description = "Identificador do scalable target retornado pelo App Auto Scaling (formato ID, pois não há ARN específico)."
  value       = aws_appautoscaling_target.this.id
}

output "resource_id" {
  description = "Resource ID usado pelo Application Auto Scaling (service/<cluster>/<service>)."
  value       = local.resource_id
}

output "cpu_policy_arn" {
  description = "ARN da policy de Target Tracking baseada em CPU, ou null quando desabilitada."
  value       = length(aws_appautoscaling_policy.cpu) > 0 ? aws_appautoscaling_policy.cpu[0].arn : null
}

output "memory_policy_arn" {
  description = "ARN da policy de Target Tracking baseada em memória, ou null quando desabilitada."
  value       = length(aws_appautoscaling_policy.memory) > 0 ? aws_appautoscaling_policy.memory[0].arn : null
}

output "alb_policy_arn" {
  description = "ARN da policy de Target Tracking baseada em ALB, ou null quando desabilitada."
  value       = length(aws_appautoscaling_policy.alb) > 0 ? aws_appautoscaling_policy.alb[0].arn : null
}

# =============================================================================
# Scheduled Scaling Outputs
# =============================================================================

output "scale_down_action_arn" {
  description = "ARN da scheduled action de scale down, ou null quando desabilitada."
  value       = length(aws_appautoscaling_scheduled_action.scale_down) > 0 ? aws_appautoscaling_scheduled_action.scale_down[0].arn : null
}

output "scale_up_action_arn" {
  description = "ARN da scheduled action de scale up, ou null quando desabilitada."
  value       = length(aws_appautoscaling_scheduled_action.scale_up) > 0 ? aws_appautoscaling_scheduled_action.scale_up[0].arn : null
}

output "scheduled_scaling_enabled" {
  description = "Indica se o scheduled scaling está habilitado."
  value       = var.enable_scheduled_scaling
}
