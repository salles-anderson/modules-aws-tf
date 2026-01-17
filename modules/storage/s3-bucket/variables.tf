variable "bucket_name" {
  description = "O nome do bucket S3. Deve ser globalmente único."
  type        = string
}

variable "versioning_enabled" {
  description = "Se `true`, o versionamento será ativado para o bucket."
  type        = bool
  default     = true
}

variable "force_ssl" {
  description = "Se `true`, uma política de bucket será adicionada para negar requisições que não usem SSL/TLS."
  type        = bool
  default     = true
}

variable "lifecycle_rule_enabled" {
  description = "Se `true`, uma regra de ciclo de vida será criada para gerenciar versões antigas de objetos."
  type        = bool
  default     = false
}

variable "noncurrent_version_transition_days" {
  description = "Número de dias para mover versões não correntes para a classe de armazenamento Standard-IA."
  type        = number
  default     = 30
}

variable "noncurrent_version_expiration_days" {
  description = "Número de dias para expirar permanentemente as versões não correntes."
  type        = number
  default     = 90
}

variable "tags" {
  description = "Um mapa de tags para adicionar ao bucket."
  type        = map(string)
  default     = {}
}
