output "role_arn" {
  description = "O ARN (Amazon Resource Name) da role criada."
  value       = aws_iam_role.this.arn
}

output "role_name" {
  description = "O nome da role criada."
  value       = aws_iam_role.this.name
}

output "role_id" {
  description = "O ID único da role criada."
  value       = aws_iam_role.this.unique_id
}
