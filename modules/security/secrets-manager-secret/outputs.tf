output "secret_id" {
  description = "ID do secret."
  value       = aws_secretsmanager_secret.this.id
}

output "secret_arn" {
  description = "ARN do secret."
  value       = aws_secretsmanager_secret.this.arn
}

output "secret_version_id" {
  description = "ID da versão criada, se secret_string foi definido."
  value       = try(aws_secretsmanager_secret_version.this[0].version_id, null)
}
