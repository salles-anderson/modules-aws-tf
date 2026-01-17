output "record_fqdns" {
  description = "Um mapa dos FQDNs dos registros criados."
  value       = { for k, v in aws_route53_record.this : k => v.fqdn }
}