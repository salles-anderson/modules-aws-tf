# ======================================================================================
# ARQUIVO DE SAÍDAS (OUTPUTS)
# ======================================================================================
# Este arquivo define as saídas do Terraform que serão exibidas ao usuário
# após a aplicação bem-sucedida da configuração.
# ======================================================================================

output "bastion_instance_id" {
  description = "O ID da instância EC2 do bastion."
  value       = module.ssm_bastion.instance_id
}

output "vpc_id" {
  description = "O ID da VPC criada."
  value       = module.network.vpc_id
}

output "connect_command" {
  description = "Comando para conectar à instância bastion usando o AWS CLI (requer o plugin Session Manager)."
  value       = "aws ssm start-session --target ${module.ssm_bastion.instance_id} --region ${var.aws_region}"
}
