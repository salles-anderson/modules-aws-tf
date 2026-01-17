output "user_pool_id" {
  description = "ID do User Pool."
  value       = aws_cognito_user_pool.this.id
}

output "user_pool_arn" {
  description = "ARN do User Pool."
  value       = aws_cognito_user_pool.this.arn
}

output "client_ids" {
  description = "Map de client IDs (mapa de IDs dos App Clients)."
  value       = { for k, v in aws_cognito_user_pool_client.clients : k => v.id }
}

# LEGACY (legado): mantém o output antigo para não quebrar integrações existentes
# - se existir o client 'legacy', retorna ele
# - senão, retorna o primeiro client do map
output "user_pool_client_id" {
  description = "ID do App Client (LEGACY / legado)."
  value = try(
    aws_cognito_user_pool_client.clients["legacy"].id,
    aws_cognito_user_pool_client.clients[sort(keys(aws_cognito_user_pool_client.clients))[0]].id
  )
}

output "issuer" {
  description = "OIDC issuer (emissor OIDC) para validação de JWT."
  value       = "https://cognito-idp.${var.aws_region}.amazonaws.com/${aws_cognito_user_pool.this.id}"
}

output "jwks_uri" {
  description = "JWKS URI (endpoint JWKS) com chaves públicas para validar JWT."
  value       = "https://cognito-idp.${var.aws_region}.amazonaws.com/${aws_cognito_user_pool.this.id}/.well-known/jwks.json"
}

output "custom_domain_url" {
  description = "Custom domain URL (URL do domínio custom), se habilitado."
  value       = var.custom_domain.enabled ? "https://${var.custom_domain.domain_name}" : null
}
