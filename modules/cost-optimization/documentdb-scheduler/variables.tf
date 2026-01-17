variable "project_name" {
  description = "Nome do projeto para tagueamento de recursos."
  type        = string
}

# =============================================================================
# DocumentDB Clusters
# =============================================================================

variable "documentdb_clusters" {
  description = "Lista de identificadores de clusters DocumentDB para gerenciar. Se vazio, usa tags para descoberta."
  type        = list(string)
  default     = []
}

variable "resource_tag_key" {
  description = "Chave da tag para descoberta automática de clusters DocumentDB."
  type        = string
  default     = null
}

variable "resource_tag_value" {
  description = "Valor da tag para descoberta automática de clusters DocumentDB."
  type        = string
  default     = null
}

# =============================================================================
# Schedule Configuration
# =============================================================================

variable "enable_schedule" {
  description = "Habilita os schedules de stop/start."
  type        = bool
  default     = true
}

variable "schedule_timezone" {
  description = "Timezone para os schedules (ex: America/Sao_Paulo)."
  type        = string
  default     = "America/Sao_Paulo"
}

variable "stop_schedule" {
  description = "Expressão cron para parar os clusters (ex: cron(0 18 ? * MON-FRI *) = 18h seg-sex)."
  type        = string
  default     = "cron(0 18 ? * MON-FRI *)"

  validation {
    condition     = can(regex("^(cron|rate)\\(.*\\)$", var.stop_schedule))
    error_message = "stop_schedule deve ser uma expressão cron ou rate válida."
  }
}

variable "start_schedule" {
  description = "Expressão cron para iniciar os clusters (ex: cron(0 8 ? * MON-FRI *) = 8h seg-sex)."
  type        = string
  default     = "cron(0 8 ? * MON-FRI *)"

  validation {
    condition     = can(regex("^(cron|rate)\\(.*\\)$", var.start_schedule))
    error_message = "start_schedule deve ser uma expressão cron ou rate válida."
  }
}

# =============================================================================
# Re-Stop Schedule (Workaround para auto-start de 7 dias)
# =============================================================================

variable "enable_restop_schedule" {
  description = "Habilita schedule adicional para re-parar clusters que foram auto-iniciados após 7 dias."
  type        = bool
  default     = false
}

variable "restop_schedule" {
  description = "Expressão cron para verificar e re-parar clusters (ex: cron(0 19 ? * MON-FRI *) = 19h seg-sex)."
  type        = string
  default     = "cron(0 19 ? * MON-FRI *)"

  validation {
    condition     = can(regex("^(cron|rate)\\(.*\\)$", var.restop_schedule))
    error_message = "restop_schedule deve ser uma expressão cron ou rate válida."
  }
}

# =============================================================================
# Lambda Configuration
# =============================================================================

variable "lambda_function_name" {
  description = "Nome da função Lambda. Se não fornecido, será gerado a partir do project_name."
  type        = string
  default     = null
}

variable "lambda_timeout" {
  description = "Timeout da função Lambda em segundos."
  type        = number
  default     = 60

  validation {
    condition     = var.lambda_timeout >= 1 && var.lambda_timeout <= 900
    error_message = "lambda_timeout deve estar entre 1 e 900 segundos."
  }
}

variable "lambda_memory_size" {
  description = "Memória da função Lambda em MB."
  type        = number
  default     = 128

  validation {
    condition     = var.lambda_memory_size >= 128 && var.lambda_memory_size <= 10240
    error_message = "lambda_memory_size deve estar entre 128 e 10240 MB."
  }
}

variable "log_retention_in_days" {
  description = "Período de retenção dos logs da Lambda em dias."
  type        = number
  default     = 14

  validation {
    condition     = contains([0, 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653], var.log_retention_in_days)
    error_message = "log_retention_in_days deve ser um valor válido do CloudWatch Logs."
  }
}

# =============================================================================
# Tags
# =============================================================================

variable "tags" {
  description = "Tags adicionais a serem aplicadas em todos os recursos."
  type        = map(string)
  default     = {}
}
