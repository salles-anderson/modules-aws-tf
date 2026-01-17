output "trail_arn" {
  description = "ARN do CloudTrail."
  value       = aws_cloudtrail.this.arn
}

output "trail_home_region" {
  description = "Região principal do trail."
  value       = aws_cloudtrail.this.home_region
}

output "trail_id" {
  description = "ID do CloudTrail."
  value       = aws_cloudtrail.this.id
}
