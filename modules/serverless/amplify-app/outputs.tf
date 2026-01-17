output "app_id" {
  description = "ID da aplicação Amplify."
  value       = aws_amplify_app.this.id
}

output "app_arn" {
  description = "ARN da aplicação Amplify."
  value       = aws_amplify_app.this.arn
}

output "default_domain" {
  description = "Domínio padrão gerado pelo Amplify."
  value       = aws_amplify_app.this.default_domain
}

output "branch_name" {
  description = "Nome da branch criada no Amplify."
  value       = try(aws_amplify_branch.this[0].branch_name, null)
}

output "branch_arn" {
  description = "ARN da branch criada no Amplify."
  value       = try(aws_amplify_branch.this[0].arn, null)
}
