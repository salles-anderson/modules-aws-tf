variable "project_name" {
  description = "Nome do projeto para taguear os recursos de forma consistente."
  type        = string
}

variable "name" {
  description = "Valor para a tag 'Name' do EIP."
  type        = string
}

variable "instance_id" {
  description = "Opcional. ID da instância EC2 para associar o EIP. Se omitido, o EIP é apenas alocado."
  type        = string
  default     = null
}

variable "tags" {
  description = "Um mapa de tags customizadas para adicionar ao EIP."
  type        = map(string)
  default     = {}
}