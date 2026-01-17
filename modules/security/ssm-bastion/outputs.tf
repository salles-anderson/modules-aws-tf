# Touched to include in patch
output "instance_id" {
  description = "O ID da instância EC2 bastion criada."
  value       = aws_instance.this.id
}

output "security_group_id" {
  description = "O ID do Security Group criado para a instância bastion."
  value       = aws_security_group.this.id
}

output "iam_role_arn" {
  description = "O ARN da IAM Role criada para a instância bastion."
  value       = aws_iam_role.this.arn
}