variable "project_name" {
  description = "Nome do projeto usado para compor tags padronizadas."
  type        = string
}

variable "cluster_name" {
  description = "Nome do cluster ECS."
  type        = string
}

variable "enable_container_insights" {
  description = "Habilita o Container Insights no cluster."
  type        = bool
  default     = true
}

variable "capacity_providers" {
  description = "Lista de capacity providers a associar (ex.: FARGATE, FARGATE_SPOT)."
  type        = list(string)
  default     = []
}

variable "default_capacity_provider_strategy" {
  description = "Estratégia padrão de capacity providers. Obrigatória se capacity_providers for configurado."
  type = list(object({
    capacity_provider = string
    weight            = optional(number, 1)
    base              = optional(number, 0)
  }))
  default = []
}

variable "tags" {
  description = "Mapa de tags adicionais."
  type        = map(string)
  default     = {}
}
