variable "project_name" {
  description = "Nome do projeto para taguear os recursos."
  type        = string
}

variable "cluster_identifier" {
  description = "Identificador do cluster DocumentDB."
  type        = string
}

variable "master_username" {
  description = "Usuário administrador do cluster."
  type        = string
}

variable "master_password" {
  description = "Senha do usuário administrador do cluster."
  type        = string
  sensitive   = true
}

variable "engine_version" {
  description = "Versão do engine DocumentDB."
  type        = string
  default     = "5.0"
}

variable "instance_class" {
  description = "Classe das instâncias (ex.: db.r6g.large)."
  type        = string
  default     = "db.t3.medium"
}

variable "instance_count" {
  description = "Quantidade de instâncias no cluster."
  type        = number
  default     = 2
}

variable "subnet_ids" {
  description = "Lista de sub-redes para o subnet group."
  type        = list(string)
}

variable "vpc_security_group_ids" {
  description = "Security Groups permitidos a acessar o cluster."
  type        = list(string)
}

variable "port" {
  description = "Porta de conexão do cluster."
  type        = number
  default     = 27017
}

variable "backup_retention_period" {
  description = "Dias de retenção de backup automático."
  type        = number
  default     = 7
}

variable "preferred_backup_window" {
  description = "Janela de backup (HH:MM-HH:MM)."
  type        = string
  default     = "03:00-05:00"
}

variable "preferred_maintenance_window" {
  description = "Janela de manutenção (ex.: sun:04:00-sun:06:00)."
  type        = string
  default     = null
}

variable "storage_encrypted" {
  description = "Habilita criptografia em repouso."
  type        = bool
  default     = true
}

variable "kms_key_id" {
  description = "KMS Key usada quando storage_encrypted = true."
  type        = string
  default     = null
}

variable "apply_immediately" {
  description = "Aplica mudanças imediatamente. Para produção recomenda-se false."
  type        = bool
  default     = false
}

variable "deletion_protection" {
  description = "Proteção contra deleção do cluster."
  type        = bool
  default     = true
}

variable "skip_final_snapshot" {
  description = "Pula snapshot final na deleção."
  type        = bool
  default     = false
}

variable "final_snapshot_identifier" {
  description = "Nome do snapshot final quando skip_final_snapshot = false."
  type        = string
  default     = null
}

variable "tags" {
  description = "Mapa de tags adicionais."
  type        = map(string)
  default     = {}
}
