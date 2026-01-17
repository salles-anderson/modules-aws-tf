variable "project_name" {
  description = "Nome do projeto para taguear os recursos de forma consistente."
  type        = string
}

variable "instance_name" {
  description = "Valor para a tag 'Name' da instância."
  type        = string
}

variable "ami_id" {
  description = "ID da Amazon Machine Image (AMI) para a instância. Pode ser obtido via data source 'aws_ami'."
  type        = string
}

variable "instance_type" {
  description = "Tipo da instância (ex: t3.micro, r6i.2xlarge)."
  type        = string
}

variable "subnet_id" {
  description = "ID da Subnet onde a instância será provisionada."
  type        = string
}

variable "key_name" {
  description = "Nome do Key Pair para acesso SSH. Opcional."
  type        = string
  default     = null
}

variable "vpc_security_group_ids" {
  description = "Lista de IDs de Security Groups para associar à instância."
  type        = list(string)
  default     = []
}

variable "associate_public_ip_address" {
  description = "Se `true`, associa um IP público à instância. Padrão é `false` por segurança."
  type        = bool
  default     = false
}

variable "user_data" {
  description = "Script a ser executado na inicialização da instância (bootstrap)."
  type        = string
  default     = null
}

variable "iam_instance_profile" {
  description = "O nome do perfil de instância IAM para associar à instância."
  type        = string
  default     = null
}

variable "tags" {
  description = "Um mapa de tags customizadas para adicionar à instância."
  type        = map(string)
  default     = {}
}