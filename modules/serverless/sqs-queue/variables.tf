variable "project_name" {
  description = "Nome do projeto para taguear recursos."
  type        = string
}

variable "queue_name" {
  description = "Nome da fila SQS. Para FIFO, deve terminar com .fifo."
  type        = string
}

variable "fifo_queue" {
  description = "Define se a fila é FIFO."
  type        = bool
  default     = false
}

variable "content_based_deduplication" {
  description = "Habilita deduplicação baseada no conteúdo (apenas FIFO)."
  type        = bool
  default     = true
}

variable "delay_seconds" {
  description = "Tempo de atraso padrão das mensagens."
  type        = number
  default     = 0
}

variable "max_message_size" {
  description = "Tamanho máximo da mensagem (bytes)."
  type        = number
  default     = 262144
}

variable "message_retention_seconds" {
  description = "Tempo de retenção das mensagens."
  type        = number
  default     = 345600
}

variable "receive_wait_time_seconds" {
  description = "Tempo de long polling."
  type        = number
  default     = 0
}

variable "visibility_timeout_seconds" {
  description = "Tempo de invisibilidade após leitura."
  type        = number
  default     = 30
}

variable "kms_master_key_id" {
  description = "KMS Key para criptografia das mensagens."
  type        = string
  default     = null
}

variable "dlq_enabled" {
  description = "Se verdadeiro, cria uma DLQ e configura redrive."
  type        = bool
  default     = false
}

variable "dlq_max_receive_count" {
  description = "Máximo de recebimentos antes de enviar para DLQ."
  type        = number
  default     = 5
}

variable "dlq_message_retention_seconds" {
  description = "Retenção de mensagens na DLQ."
  type        = number
  default     = 1209600
}

variable "tags" {
  description = "Mapa de tags adicionais."
  type        = map(string)
  default     = {}
}
