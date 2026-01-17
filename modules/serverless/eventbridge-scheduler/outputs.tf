output "scheduler_arn" {
  description = "ARN do cronograma EventBridge."
  value       = aws_scheduler_schedule.this.arn
}

output "scheduler_role_arn" {
  description = "ARN da IAM Role utilizada pelo Scheduler."
  value       = aws_iam_role.scheduler.arn
}
