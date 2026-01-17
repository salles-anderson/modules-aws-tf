output "protection_id" {
  description = "ID da proteção Shield (ARN do recurso protegido)."
  value       = aws_shield_protection.this.id
}
