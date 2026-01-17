output "certificate_arn" {
  description = "O ARN do certificado ACM criado."
  value       = module.certificate.arn
}

output "api_endpoint_fqdn" {
  description = "O FQDN completo do endpoint da API."
  value       = module.dns_record.record_fqdns["api"]
}
