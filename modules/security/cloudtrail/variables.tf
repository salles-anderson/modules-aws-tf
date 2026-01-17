variable "project_name" {
  description = "Nome do projeto para compor tags."
  type        = string
}

variable "trail_name" {
  description = "Nome do CloudTrail."
  type        = string
}

variable "s3_bucket_name" {
  description = "Bucket onde os logs serão gravados."
  type        = string
}

variable "create_s3_bucket" {
  description = "Se true, cria o bucket informado. Caso false, usa um bucket existente."
  type        = bool
  default     = true
}

variable "s3_encryption_type" {
  description = "Tipo de criptografia do bucket (AES256 ou aws:kms)."
  type        = string
  default     = "AES256"
}

variable "s3_kms_key_id" {
  description = "KMS Key para o bucket quando s3_encryption_type = aws:kms."
  type        = string
  default     = null
}

variable "include_global_service_events" {
  description = "Captura eventos de serviços globais."
  type        = bool
  default     = true
}

variable "is_multi_region_trail" {
  description = "Se true, registra eventos de todas as regiões."
  type        = bool
  default     = true
}

variable "enable_log_file_validation" {
  description = "Habilita validação de integridade dos arquivos de log."
  type        = bool
  default     = true
}

variable "kms_key_id" {
  description = "KMS Key usada pelo CloudTrail para criptografar logs."
  type        = string
  default     = null
}

variable "cloud_watch_logs_group_arn" {
  description = "ARN do Log Group para integração com CloudWatch Logs."
  type        = string
  default     = null
}

variable "cloud_watch_logs_role_arn" {
  description = "ARN da role para publicar no CloudWatch Logs."
  type        = string
  default     = null
}

variable "is_organization_trail" {
  description = "Se true, cria um trail da organização."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Mapa de tags adicionais."
  type        = map(string)
  default     = {}
}
