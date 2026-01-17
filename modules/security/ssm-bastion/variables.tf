# Touched to include in patch
variable "project_name" {
  description = "Nome do projeto para taguear os recursos de forma consistente."
  type        = string
}

variable "name" {
  description = "Nome para a instância EC2 do bastion."
  type        = string
  default     = "ssm-bastion"
}

variable "vpc_id" {
  description = "ID da VPC onde a instância bastion será criada."
  type        = string
}

variable "subnet_id" {
  description = "ID da sub-rede onde a instância bastion será criada. Pode ser uma sub-rede privada."
  type        = string
}

variable "instance_type" {
  description = "O tipo da instância EC2 para o bastion."
  type        = string
  default     = "t3.nano"
}

variable "ami_id" {
  description = "Opcional. A AMI para a instância. Se não fornecida, usará a última Amazon Linux 2."
  type        = string
  default     = null
}

variable "tags" {
  description = "Um mapa de tags customizadas para adicionar aos recursos."
  type        = map(string)
  default     = {}
}