variable "project_name" {
  description = "Nome do projeto para taguear recursos."
  type        = string
}

variable "name" {
  description = "Nome base do NLB."
  type        = string
}

variable "internal" {
  description = "Se true, cria um NLB interno."
  type        = bool
  default     = false
}

variable "vpc_id" {
  description = "ID da VPC onde o NLB e os target groups existirão."
  type        = string
}

variable "subnet_mappings" {
  description = "Lista de subnets com EIP opcional para o NLB. Um item por AZ."
  type = list(object({
    subnet_id     = string
    allocation_id = optional(string)
  }))

  validation {
    condition     = length(var.subnet_mappings) > 0
    error_message = "Informe ao menos uma subnet para o NLB."
  }
}

variable "target_groups" {
  description = "Mapa de target groups. Use target_type \"ip\" para Fargate."
  type = map(object({
    port        = number
    protocol    = string
    target_type = optional(string, "ip")
    health_check = optional(object({
      enabled             = optional(bool)
      interval            = optional(number)
      healthy_threshold   = optional(number)
      unhealthy_threshold = optional(number)
      timeout             = optional(number)
      protocol            = optional(string)
      port                = optional(string)
      matcher             = optional(string)
    }), {})
  }))
  default = {}
}

variable "listeners" {
  description = "Mapa de listeners apontando para target groups."
  type = map(object({
    port             = number
    protocol         = string
    target_group_key = string
    certificate_arn  = optional(string)
    ssl_policy       = optional(string)
    alpn_policy      = optional(any)
  }))
  default = {}
}

variable "enable_cross_zone_load_balancing" {
  description = "Habilita balanceamento cross-AZ no NLB."
  type        = bool
  default     = true
}

variable "enable_deletion_protection" {
  description = "Protege o NLB contra deleção acidental."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Mapa de tags adicionais."
  type        = map(string)
  default     = {}
}
