variable "project_name" {
  description = "Nome do projeto para taguear os recursos de forma consistente."
  type        = string
}

variable "name" {
  description = "Nome base para o ALB e recursos associados."
  type        = string
}

variable "internal" {
  description = "Se `true`, o ALB será interno. Se `false`, será de frente para a internet."
  type        = bool
  default     = false
}

variable "vpc_id" {
  description = "ID da VPC onde o ALB será criado."
  type        = string
}

variable "subnet_ids" {
  description = "Lista de IDs de sub-redes para anexar ao ALB."
  type        = list(string)
}

variable "security_group_ids" {
  description = "Lista de IDs de Security Groups para anexar ao ALB."
  type        = list(string)
}

variable "target_groups" {
  description = "Um mapa de objetos que definem os target groups. A chave do mapa será usada no nome do TG."
  type        = any
  default     = {}
}

variable "listeners" {
  description = "Um mapa de objetos que definem os listeners. A chave do mapa será usada na identificação do listener."
  type        = any
  default     = {}
}

variable "access_logs" {
  description = "Configurações de log de acesso para o ALB. `bucket` é o nome do bucket S3 e `prefix` é opcional."
  type = object({
    enabled = bool
    bucket  = optional(string)
    prefix  = optional(string)
  })
  default = {
    enabled = false
  }
}

variable "tags" {
  description = "Um mapa de tags customizadas para adicionar aos recursos."
  type        = map(string)
  default     = {}
}