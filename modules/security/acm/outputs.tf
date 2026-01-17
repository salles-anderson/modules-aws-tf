output "arn" {
  description = "O ARN (Amazon Resource Name) do certificado ACM."
  value       = aws_acm_certificate.this.arn
}

output "id" {
  description = "O ID do certificado ACM."
  value       = aws_acm_certificate.this.id
}

output "status" {
  description = "O status do certificado. Geralmente PENDING_VALIDATION, ISSUED, ou FAILED."
  value       = aws_acm_certificate.this.status
}

output "validation_fqdns" {
  description = "Uma lista dos FQDNs dos registros de validação criados no Route53."
  value       = [for record in aws_route53_record.validation : record.fqdn]
}
