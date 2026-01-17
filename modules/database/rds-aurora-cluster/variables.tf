variable "project_name" {
  description = "Nome do projeto para taguear recursos."
  type        = string
}

variable "identifier" {
  description = "Identificador do cluster Aurora."
  type        = string
}

variable "engine" {
  description = "Engine do Aurora (aurora-mysql ou aurora-postgresql)."
  type        = string
  default     = "aurora-mysql"

  validation {
    condition     = contains(["aurora-mysql", "aurora-postgresql"], var.engine)
    error_message = "engine deve ser aurora-mysql ou aurora-postgresql."
  }
}

variable "engine_version" {
  description = "Versão do engine. Quando null usa default da AWS."
  type        = string
  default     = null
}

variable "instance_class" {
  description = "Classe das instâncias do cluster (ex: db.r6g.large)."
  type        = string
}

variable "instance_count" {
  description = "Número total de instâncias no cluster (writer + readers)."
  type        = number
  default     = 2

  validation {
    condition     = var.instance_count >= 1
    error_message = "instance_count deve ser pelo menos 1."
  }
}

variable "db_name" {
  description = "Nome do banco de dados inicial."
  type        = string
  default     = null
}

variable "username" {
  description = "Usuário mestre do cluster."
  type        = string
}

variable "password" {
  description = "Senha do usuário mestre."
  type        = string
  sensitive   = true
}

variable "port" {
  description = "Porta do banco. Se null, usa 3306 (MySQL) ou 5432 (Postgres)."
  type        = number
  default     = null
}

variable "subnet_ids" {
  description = "Subnets usadas no DB subnet group."
  type        = list(string)
}

variable "vpc_security_group_ids" {
  description = "Security groups associados ao cluster."
  type        = list(string)
}

variable "cluster_parameter_group_name" {
  description = "Parameter group aplicado ao cluster (opcional)."
  type        = string
  default     = null
}

variable "instance_parameter_group_name" {
  description = "Parameter group aplicado às instâncias (opcional)."
  type        = string
  default     = null
}

variable "storage_encrypted" {
  description = "Habilita criptografia do cluster."
  type        = bool
  default     = true
}

variable "backup_retention_period" {
  description = "Dias de retenção de backup automático."
  type        = number
  default     = 7
}

variable "preferred_backup_window" {
  description = "Janela de backup (hh24:mi-hh24:mi, UTC)."
  type        = string
  default     = null
}

variable "preferred_maintenance_window" {
  description = "Janela de manutenção (ddd:hh24:mi-ddd:hh24:mi, UTC)."
  type        = string
  default     = null
}

variable "enabled_cloudwatch_logs_exports" {
  description = "Tipos de log exportados para CloudWatch Logs (ex: [\"audit\",\"error\",\"slowquery\"], [\"postgresql\"])."
  type        = list(string)
  default     = []
}

variable "enable_local_write_forwarding" {
  description = "Habilita write forwarding (apenas Aurora MySQL)."
  type        = bool
  default     = true
}

variable "deletion_protection" {
  description = "Impede deleção acidental do cluster."
  type        = bool
  default     = false
}

variable "publicly_accessible" {
  description = "Permite acesso público às instâncias."
  type        = bool
  default     = false
}

variable "apply_immediately" {
  description = "Aplica mudanças imediatamente (true) ou na janela de manutenção (false)."
  type        = bool
  default     = false
}

variable "skip_final_snapshot" {
  description = "Pula snapshot final na destruição."
  type        = bool
  default     = false
}

variable "final_snapshot_identifier" {
  description = "Identificador do snapshot final (necessário se skip_final_snapshot = false)."
  type        = string
  default     = null
}

variable "auto_minor_version_upgrade" {
  description = "Habilita atualização automática de versão minor nas instâncias."
  type        = bool
  default     = true
}

variable "performance_insights_enabled" {
  description = "Habilita Performance Insights nas instâncias."
  type        = bool
  default     = false
}

variable "performance_insights_retention_period" {
  description = "Período de retenção do Performance Insights (7 ou 731 dias)."
  type        = number
  default     = null

  validation {
    condition     = var.performance_insights_retention_period == null || contains([7, 731], var.performance_insights_retention_period)
    error_message = "performance_insights_retention_period deve ser 7 ou 731 (ou null para default)."
  }
}

variable "performance_insights_kms_key_id" {
  description = "KMS Key para Performance Insights."
  type        = string
  default     = null
}

variable "monitoring_interval" {
  description = "Intervalo do Enhanced Monitoring (0 desabilita)."
  type        = number
  default     = 0

  validation {
    condition     = contains([0, 1, 5, 10, 15, 30, 60], var.monitoring_interval)
    error_message = "monitoring_interval deve ser 0, 1, 5, 10, 15, 30 ou 60."
  }
}

variable "create_monitoring_role" {
  description = "Cria a IAM role para Enhanced Monitoring quando não fornecida."
  type        = bool
  default     = true
}

variable "monitoring_role_name" {
  description = "Nome da role de Enhanced Monitoring (quando criada pelo módulo)."
  type        = string
  default     = null
}

variable "monitoring_role_arn" {
  description = "ARN de uma role existente de Enhanced Monitoring."
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags adicionais."
  type        = map(string)
  default     = {}
}
