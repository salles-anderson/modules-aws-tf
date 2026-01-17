variable "project_name" {
  description = "Nome do projeto para consistência nas tags (não aplicável ao recurso Shield)."
  type        = string
}

variable "protection_name" {
  description = "Nome amigável da proteção Shield."
  type        = string
}

variable "resource_arn" {
  description = "ARN do recurso protegido (ex.: ALB, CloudFront)."
  type        = string
}

variable "health_check_arns" {
  description = "ARNs de health checks (opcional) usados pelo Shield."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Mapa de tags adicionais (não suportado pelo recurso, mantido por consistência de interface)."
  type        = map(string)
  default     = {}
}
