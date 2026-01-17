variable "aws_region" {
  description = "A região da AWS onde os recursos serão criados."
  type        = string
  default     = "us-east-1"
}

variable "root_domain_name" {
  description = "O nome do domínio raiz da Hosted Zone (ex: 'exemplo.com.br')."
  type        = string
  default     = "exemplo.com.br" # Altere para seu domínio
}
