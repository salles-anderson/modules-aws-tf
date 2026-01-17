variable "domain_name" {
  description = "O nome de domínio principal para o qual o certificado será emitido."
  type        = string

  validation {
    condition     = can(regex("^(\\*\\.)?(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?\\.)+[a-zA-Z]{2,6}$", var.domain_name))
    error_message = "O nome de domínio principal deve ser um FQDN válido (pode começar com *. para wildcard)."
  }
}

variable "subject_alternative_names" {
  description = "Uma lista de nomes de domínio alternativos (SANs) a serem incluídos no certificado."
  type        = list(string)
  default     = []

  validation {
    condition     = alltrue([for san in var.subject_alternative_names : can(regex("^(\\*\\.)?(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?\\.)+[a-zA-Z]{2,6}$", san))])
    error_message = "Cada nome de domínio alternativo deve ser um FQDN válido (pode começar com *. para wildcard)."
  }
}

variable "hosted_zone_id" {
  description = "O ID da Hosted Zone do Route53 onde os registros de validação serão criados."
  type        = string

  validation {
    condition     = substr(var.hosted_zone_id, 0, 1) == "Z"
    error_message = "O ID da Hosted Zone deve começar com 'Z'."
  }
}

variable "tags" {
  description = "Um mapa de tags para associar aos recursos."
  type        = map(string)
  default     = {}
}
