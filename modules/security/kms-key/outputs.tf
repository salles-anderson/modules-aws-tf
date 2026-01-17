output "key_id" {
  description = "ID da chave KMS."
  value       = aws_kms_key.this.key_id
}

output "key_arn" {
  description = "ARN da chave KMS."
  value       = aws_kms_key.this.arn
}

output "alias" {
  description = "Alias criado para a chave, se definido."
  value       = try(aws_kms_alias.this[0].name, null)
}
