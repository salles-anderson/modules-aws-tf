output "repository_arn" {
  description = "ARN do repositório ECR."
  value       = aws_ecr_repository.this.arn
}

output "repository_name" {
  description = "Nome do repositório ECR."
  value       = aws_ecr_repository.this.name
}

output "repository_url" {
  description = "URL completa para realizar push/pull (registry/repo)."
  value       = aws_ecr_repository.this.repository_url
}

output "registry_id" {
  description = "ID do registro AWS associado ao repositório."
  value       = aws_ecr_repository.this.registry_id
}
