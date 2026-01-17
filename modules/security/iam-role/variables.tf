variable "role_name" {
  description = "O nome da role a ser criada."
  type        = string
}

variable "assume_role_policy_json" {
  description = "A política de confiança (assume role policy) em formato JSON. Define quem pode assumir esta role."
  type        = string
}

variable "policy_arns" {
  description = "Uma lista de ARNs de políticas (gerenciadas pela AWS ou customizadas) para anexar à role."
  type        = list(string)
  default     = []
}

variable "path" {
  description = "O caminho para a role."
  type        = string
  default     = "/"
}

variable "description" {
  description = "A descrição da role."
  type        = string
  default     = null
}

variable "tags" {
  description = "Um mapa de tags para adicionar à role."
  type        = map(string)
  default     = {}
}
