variable "project_name" {
  description = "Nome do projeto para tagueamento de recursos."
  type        = string
}

# =============================================================================
# SNS Configuration
# =============================================================================

variable "create_sns_topic" {
  description = "Criar um novo tópico SNS para notificações de alarmes."
  type        = bool
  default     = false
}

variable "sns_topic_name" {
  description = "Nome do tópico SNS. Se não fornecido, será usado '{project_name}-alarms'."
  type        = string
  default     = null
}

variable "sns_kms_key_id" {
  description = "ARN ou ID da chave KMS para criptografia do tópico SNS."
  type        = string
  default     = null
}

variable "sns_topic_arns" {
  description = "Lista de ARNs de tópicos SNS existentes para receber notificações de alarmes."
  type        = list(string)
  default     = []
}

variable "sns_subscriptions" {
  description = "Mapa de assinaturas do tópico SNS criado pelo módulo. Cada entrada deve conter 'protocol' e 'endpoint'."
  type = map(object({
    protocol = string
    endpoint = string
  }))
  default = {}

  validation {
    condition = alltrue([
      for k, v in var.sns_subscriptions :
      contains(["email", "email-json", "http", "https", "lambda", "sms", "sqs", "application"], v.protocol)
    ])
    error_message = "protocol deve ser um dos valores: email, email-json, http, https, lambda, sms, sqs, application."
  }
}

# =============================================================================
# Custom Metric Alarms
# =============================================================================

variable "metric_alarms" {
  description = "Mapa de alarmes de métricas customizados."
  type        = any
  default     = {}
}

# =============================================================================
# Composite Alarms
# =============================================================================

variable "composite_alarms" {
  description = "Mapa de alarmes compostos. Cada entrada deve conter 'alarm_rule' e opcionalmente 'description', 'actions_enabled', 'alarm_actions', 'ok_actions', 'insufficient_data_actions'."
  type = map(object({
    alarm_rule                          = string
    description                         = optional(string)
    actions_enabled                     = optional(bool)
    alarm_actions                       = optional(list(string))
    ok_actions                          = optional(list(string))
    insufficient_data_actions           = optional(list(string))
    actions_suppressor                  = optional(string)
    actions_suppressor_wait_period      = optional(number)
    actions_suppressor_extension_period = optional(number)
    tags                                = optional(map(string))
  }))
  default = {}
}

# =============================================================================
# ECS Service Alarms (Presets)
# =============================================================================

variable "ecs_service_alarms" {
  description = "Mapa de alarmes pré-configurados para serviços ECS. Cada entrada deve conter 'cluster_name' e 'service_name'."
  type = map(object({
    cluster_name              = string
    service_name              = string
    cpu_threshold             = optional(number)
    cpu_period                = optional(number)
    cpu_evaluation_periods    = optional(number)
    memory_threshold          = optional(number)
    memory_period             = optional(number)
    memory_evaluation_periods = optional(number)
    actions_enabled           = optional(bool)
    alarm_actions             = optional(list(string))
    ok_actions                = optional(list(string))
    insufficient_data_actions = optional(list(string))
    tags                      = optional(map(string))
  }))
  default = {}
}

# =============================================================================
# RDS Alarms (Presets)
# =============================================================================

variable "rds_alarms" {
  description = "Mapa de alarmes pré-configurados para instâncias RDS. Cada entrada deve conter 'db_instance_identifier'."
  type = map(object({
    db_instance_identifier         = string
    cpu_threshold                  = optional(number)
    cpu_period                     = optional(number)
    cpu_evaluation_periods         = optional(number)
    memory_threshold_bytes         = optional(number)
    memory_period                  = optional(number)
    memory_evaluation_periods      = optional(number)
    storage_threshold_bytes        = optional(number)
    storage_period                 = optional(number)
    storage_evaluation_periods     = optional(number)
    connections_threshold          = optional(number)
    connections_period             = optional(number)
    connections_evaluation_periods = optional(number)
    actions_enabled                = optional(bool)
    alarm_actions                  = optional(list(string))
    ok_actions                     = optional(list(string))
    insufficient_data_actions      = optional(list(string))
    tags                           = optional(map(string))
  }))
  default = {}
}

# =============================================================================
# Lambda Alarms (Presets)
# =============================================================================

variable "lambda_alarms" {
  description = "Mapa de alarmes pré-configurados para funções Lambda. Cada entrada deve conter 'function_name'."
  type = map(object({
    function_name                = string
    errors_threshold             = optional(number)
    errors_period                = optional(number)
    errors_evaluation_periods    = optional(number)
    duration_threshold_ms        = optional(number)
    duration_period              = optional(number)
    duration_evaluation_periods  = optional(number)
    throttles_threshold          = optional(number)
    throttles_period             = optional(number)
    throttles_evaluation_periods = optional(number)
    actions_enabled              = optional(bool)
    alarm_actions                = optional(list(string))
    ok_actions                   = optional(list(string))
    insufficient_data_actions    = optional(list(string))
    tags                         = optional(map(string))
  }))
  default = {}
}

# =============================================================================
# ALB Alarms (Presets)
# =============================================================================

variable "alb_alarms" {
  description = "Mapa de alarmes pré-configurados para ALBs. Cada entrada deve conter 'load_balancer_arn_suffix' e 'target_group_arn_suffix'."
  type = map(object({
    load_balancer_arn_suffix     = string
    target_group_arn_suffix      = string
    error_5xx_threshold          = optional(number)
    error_5xx_period             = optional(number)
    error_5xx_evaluation_periods = optional(number)
    unhealthy_threshold          = optional(number)
    unhealthy_period             = optional(number)
    unhealthy_evaluation_periods = optional(number)
    latency_threshold_seconds    = optional(number)
    latency_period               = optional(number)
    latency_evaluation_periods   = optional(number)
    actions_enabled              = optional(bool)
    alarm_actions                = optional(list(string))
    ok_actions                   = optional(list(string))
    insufficient_data_actions    = optional(list(string))
    tags                         = optional(map(string))
  }))
  default = {}
}

# =============================================================================
# Tags
# =============================================================================

variable "tags" {
  description = "Tags adicionais a serem aplicadas em todos os recursos."
  type        = map(string)
  default     = {}
}
