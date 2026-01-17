output "id" {
  description = "O ID do Security Group."
  value       = aws_security_group.this.id
}

output "arn" {
  description = "O ARN do Security Group."
  value       = aws_security_group.this.arn
}