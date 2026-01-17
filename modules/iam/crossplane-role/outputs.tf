output "iam_role_arn" {
  description = "O ARN da IAM Role criada para o Crossplane."
  value       = aws_iam_role.crossplane.arn
}