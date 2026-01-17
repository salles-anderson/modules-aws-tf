variable "project_name" {
  description = "Identificador do projeto para tagging."
  type        = string
}

variable "schedule_name" {
  description = "Nome do cronograma EventBridge Scheduler."
  type        = string
}

variable "schedule_description" {
  description = "Descrição do cronograma."
  type        = string
  default     = null
}

variable "schedule_expression" {
  description = "Expressão rate/cron."
  type        = string
  default     = "rate(5 minutes)"
}

variable "schedule_timezone" {
  description = "Fuso horário utilizado pelo cronograma."
  type        = string
  default     = "UTC"
}

variable "schedule_retry_attempts" {
  description = "Número máximo de tentativas."
  type        = number
  default     = null
}

variable "schedule_event_age_in_seconds" {
  description = "Tempo máximo que o evento permanece válido."
  type        = number
  default     = null
}

variable "schedule_group_name" {
  description = "Nome do grupo do EventBridge Scheduler."
  type        = string
  default     = null
}

variable "schedule_kms_key_arn" {
  description = "ARN de chave KMS para criptografar payloads."
  type        = string
  default     = null
}

variable "target_input" {
  description = "Payload enviado para a Lambda."
  type        = string
  default     = "{}"
}

variable "lambda_function_arn" {
  description = "ARN da função Lambda alvo."
  type        = string
}

variable "lambda_function_name" {
  description = "Nome da função Lambda alvo (usado no aws_lambda_permission)."
  type        = string
}

variable "scheduler_role_name" {
  description = "Nome customizado para a IAM Role do Scheduler."
  type        = string
  default     = null
}

variable "enable_schedule" {
  description = "Define se o cronograma fica habilitado."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Mapa de tags adicionais."
  type        = map(string)
  default     = {}
}
