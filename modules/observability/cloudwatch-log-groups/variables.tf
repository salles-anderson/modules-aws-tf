variable "project_name" {
  description = "Nome do projeto para tagueamento de recursos."
  type        = string
}

variable "log_groups" {
  description = "Mapa de log groups a serem criados. Cada entrada deve conter 'name' e opcionalmente 'retention_in_days', 'kms_key_id', 'log_group_class', 'skip_destroy' e 'tags'."
  type = map(object({
    name              = string
    retention_in_days = optional(number)
    kms_key_id        = optional(string)
    log_group_class   = optional(string)
    skip_destroy      = optional(bool)
    tags              = optional(map(string))
  }))
  default = {}
}

variable "default_retention_in_days" {
  description = "Período de retenção padrão em dias para log groups (quando não especificado individualmente). Use 0 para retenção infinita."
  type        = number
  default     = 30

  validation {
    condition     = contains([0, 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653], var.default_retention_in_days)
    error_message = "default_retention_in_days deve ser um valor válido: 0, 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1096, 1827, 2192, 2557, 2922, 3288 ou 3653."
  }
}

variable "subscription_filters" {
  description = "Mapa de filtros de assinatura para streaming de logs. Cada entrada deve conter 'log_group_key', 'destination_arn' e opcionalmente 'filter_pattern', 'role_arn' e 'distribution'."
  type = map(object({
    log_group_key   = string
    destination_arn = string
    filter_pattern  = optional(string)
    role_arn        = optional(string)
    distribution    = optional(string)
  }))
  default = {}

  validation {
    condition = alltrue([
      for k, v in var.subscription_filters :
      v.distribution == null || contains(["Random", "ByLogStream"], v.distribution)
    ])
    error_message = "distribution deve ser 'Random' ou 'ByLogStream' (ou null)."
  }
}

variable "metric_filters" {
  description = "Mapa de filtros de métricas para extração de métricas dos logs. Cada entrada deve conter 'log_group_key', 'pattern', 'metric_name', 'metric_namespace' e opcionalmente 'metric_value', 'default_value', 'unit' e 'dimensions'."
  type = map(object({
    log_group_key    = string
    pattern          = string
    metric_name      = string
    metric_namespace = string
    metric_value     = optional(string)
    default_value    = optional(number)
    unit             = optional(string)
    dimensions       = optional(map(string))
  }))
  default = {}

  validation {
    condition = alltrue([
      for k, v in var.metric_filters :
      v.unit == null || contains([
        "Seconds", "Microseconds", "Milliseconds", "Bytes", "Kilobytes", "Megabytes",
        "Gigabytes", "Terabytes", "Bits", "Kilobits", "Megabits", "Gigabits", "Terabits",
        "Percent", "Count", "Bytes/Second", "Kilobytes/Second", "Megabytes/Second",
        "Gigabytes/Second", "Terabytes/Second", "Bits/Second", "Kilobits/Second",
        "Megabits/Second", "Gigabits/Second", "Terabits/Second", "Count/Second", "None"
      ], v.unit)
    ])
    error_message = "unit deve ser uma unidade CloudWatch válida (ex: Seconds, Count, Percent, None)."
  }
}

variable "tags" {
  description = "Tags adicionais a serem aplicadas em todos os recursos."
  type        = map(string)
  default     = {}
}
