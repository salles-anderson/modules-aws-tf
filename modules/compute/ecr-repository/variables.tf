variable "project_name" {
  description = "Nome do projeto usado para compor tags padronizadas."
  type        = string
}

variable "repository_name" {
  description = "Nome do repositório ECR."
  type        = string
}

variable "image_tag_mutability" {
  description = "Define se as tags são mutáveis (MUTABLE) ou imutáveis (IMMUTABLE)."
  type        = string
  default     = "MUTABLE"
}

variable "scan_on_push" {
  description = "Habilita image scanning on push."
  type        = bool
  default     = true
}

variable "encryption_type" {
  description = "Tipo de criptografia (AES256 ou KMS)."
  type        = string
  default     = "AES256"
}

variable "kms_key_arn" {
  description = "ARN da chave KMS quando encryption_type = KMS."
  type        = string
  default     = null
}

variable "lifecycle_policy" {
  description = "Política de lifecycle em JSON para limpeza de imagens."
  type        = string
  default     = null
}

variable "tags" {
  description = "Mapa de tags adicionais."
  type        = map(string)
  default     = {}
}
