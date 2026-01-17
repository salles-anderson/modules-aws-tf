variable "project_name" {
  description = "Nome do projeto para taguear recursos."
  type        = string
}

variable "replication_group_id" {
  description = "Identificador do replication group Redis."
  type        = string
}

variable "description" {
  description = "Descrição do replication group."
  type        = string
  default     = "Redis cluster gerenciado"
}

variable "engine_version" {
  description = "Versão do Redis."
  type        = string
  default     = "7.1"
}

variable "node_type" {
  description = "Classe de instância do cache (ex.: cache.t3.small)."
  type        = string
  default     = "cache.t3.small"
}

variable "num_cache_clusters" {
  description = "Quantidade de nós no cluster (modo não clusterizado)."
  type        = number
  default     = 2
}

variable "port" {
  description = "Porta de conexão."
  type        = number
  default     = 6379
}

variable "maintenance_window" {
  description = "Janela de manutenção (ex.: sun:04:00-sun:06:00)."
  type        = string
  default     = null
}

variable "snapshot_window" {
  description = "Janela de snapshot (HH:MM-HH:MM)."
  type        = string
  default     = null
}

variable "snapshot_retention_limit" {
  description = "Dias de retenção de snapshot."
  type        = number
  default     = 7
}

variable "subnet_ids" {
  description = "Subnets onde o Redis será implantado."
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security Groups permitidos a acessar o Redis."
  type        = list(string)
}

variable "parameter_group_name" {
  description = "Parameter group a associar."
  type        = string
  default     = null
}

variable "apply_immediately" {
  description = "Aplica alterações imediatamente."
  type        = bool
  default     = false
}

variable "at_rest_encryption_enabled" {
  description = "Habilita criptografia em repouso."
  type        = bool
  default     = true
}

variable "transit_encryption_enabled" {
  description = "Habilita criptografia em trânsito (TLS)."
  type        = bool
  default     = true
}

variable "auth_token" {
  description = "Token de autenticação (Redis AUTH)."
  type        = string
  default     = null
  sensitive   = true
}

variable "multi_az_enabled" {
  description = "Habilita Multi-AZ."
  type        = bool
  default     = true
}

variable "automatic_failover_enabled" {
  description = "Habilita failover automático."
  type        = bool
  default     = true
}

variable "preferred_cache_cluster_azs" {
  description = "Lista de AZs preferidas por nó (mesmo tamanho de num_cache_clusters)."
  type        = list(string)
  default     = []
}

variable "kms_key_id" {
  description = "KMS Key para criptografia em repouso."
  type        = string
  default     = null
}

variable "tags" {
  description = "Mapa de tags adicionais."
  type        = map(string)
  default     = {}
}
