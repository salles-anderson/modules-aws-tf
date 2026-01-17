# ======================================================================================
# ARQUIVO DE VARIÁVEIS
# ======================================================================================
# Este arquivo define as variáveis de entrada para o exemplo de infraestrutura
# do SSM Bastion.
# ======================================================================================

variable "aws_region" {
  description = "Região da AWS onde os recursos serão criados."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Nome do projeto, usado para taguear e nomear recursos."
  type        = string
  default     = "SSMBastionExample"
}
