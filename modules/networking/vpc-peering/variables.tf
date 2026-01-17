variable "requester_vpc_id" {
  description = "ID da VPC que solicita a conexão (Nova VPC)."
  type        = string
}

variable "requester_vpc_cidr" {
  description = "Bloco CIDR da VPC solicitante (e.g., 172.16.0.0/16)."
  type        = string
}

variable "requester_route_table_id" {
  description = "ID da Tabela de Rotas principal ou específica da VPC Solicitante a ser atualizada."
  type        = string
}

variable "accepter_vpc_id" {
  description = "ID da VPC que aceita a conexão (VPC Padrão Antiga)."
  type        = string
}

variable "accepter_vpc_cidr" {
  description = "Bloco CIDR da VPC aceitante (e.g., 172.31.0.0/16)."
  type        = string
}

variable "accepter_route_table_id" {
  description = "ID da Tabela de Rotas principal ou específica da VPC Aceitante a ser atualizada."
  type        = string
}

variable "requester_name" {
  description = "Nome descritivo do Solicitante (usado na tag)."
  type        = string
}

variable "accepter_name" {
  description = "Nome descritivo do Aceitante (usado na tag)."
  type        = string
}