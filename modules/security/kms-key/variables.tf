variable "project_name" {
  description = "Nome do projeto para compor tags."
  type        = string
}

variable "description" {
  description = "Descrição da chave KMS."
  type        = string
  default     = "Chave gerenciada pelo cliente"
}

variable "deletion_window_in_days" {
  description = "Janela de deleção (dias)."
  type        = number
  default     = 30
}

variable "enable_key_rotation" {
  description = "Habilita rotação anual automática."
  type        = bool
  default     = true
}

variable "is_enabled" {
  description = "Habilita a chave."
  type        = bool
  default     = true
}

variable "multi_region" {
  description = "Define a chave como multi-região."
  type        = bool
  default     = false
}

variable "policy" {
  description = "Política IAM em JSON. Quando nulo, usa política padrão gerenciada pela AWS."
  type        = string
  default     = null
}

variable "alias_name" {
  description = "Nome do alias (sem prefixo alias/)."
  type        = string
  default     = null
}

variable "tags" {
  description = "Mapa de tags adicionais."
  type        = map(string)
  default     = {}
}
