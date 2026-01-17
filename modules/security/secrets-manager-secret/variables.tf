variable "project_name" {
  description = "Nome do projeto para compor tags."
  type        = string
}

variable "name" {
  description = "Nome do secret."
  type        = string
}

variable "description" {
  description = "Descrição do secret."
  type        = string
  default     = null
}

variable "kms_key_id" {
  description = "KMS Key para criptografia do secret."
  type        = string
  default     = null
}

variable "recovery_window_in_days" {
  description = "Janela de recuperação antes da deleção permanente."
  type        = number
  default     = 30
}

variable "force_overwrite_replica_secret" {
  description = "Força overwrite em segredos replicados."
  type        = bool
  default     = false
}

variable "secret_string" {
  description = "Valor do secret em texto claro (opcional)."
  type        = string
  default     = null
  sensitive   = true
}

variable "tags" {
  description = "Mapa de tags adicionais."
  type        = map(string)
  default     = {}
}
