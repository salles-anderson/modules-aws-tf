variable "project_name" {
  description = "Nome do projeto usado para compor nomes e tags padronizadas."
  type        = string
}

variable "cluster_name" {
  description = "Nome do cluster ECS onde o serviço está registrado (não usar ARN)."
  type        = string

  validation {
    condition     = length(trimspace(var.cluster_name)) > 0
    error_message = "cluster_name não pode ser vazio."
  }
}

variable "service_name" {
  description = "Nome do serviço ECS cujo desired_count será ajustado."
  type        = string

  validation {
    condition     = length(trimspace(var.service_name)) > 0
    error_message = "service_name não pode ser vazio."
  }
}

variable "min_capacity" {
  description = "Quantidade mínima de tasks (desired_count) permitida."
  type        = number

  validation {
    condition     = var.min_capacity >= 0
    error_message = "min_capacity deve ser maior ou igual a zero."
  }
}

variable "max_capacity" {
  description = "Quantidade máxima de tasks (desired_count) permitida."
  type        = number

  validation {
    condition     = var.max_capacity >= var.min_capacity
    error_message = "max_capacity deve ser maior ou igual a min_capacity."
  }
}

variable "enable_cpu_scaling" {
  description = "Habilita a policy de Target Tracking usando CPU média do serviço."
  type        = bool
  default     = true
}

variable "cpu_target_value" {
  description = "Valor alvo de utilização média de CPU do serviço ECS."
  type        = number
  default     = 60

  validation {
    condition     = !var.enable_cpu_scaling || (var.cpu_target_value >= 10 && var.cpu_target_value <= 90)
    error_message = "cpu_target_value deve estar entre 10 e 90 quando o scaling por CPU estiver habilitado."
  }
}

variable "enable_memory_scaling" {
  description = "Habilita a policy de Target Tracking usando memória média do serviço."
  type        = bool
  default     = true
}

variable "memory_target_value" {
  description = "Valor alvo de utilização média de memória do serviço ECS."
  type        = number
  default     = 70

  validation {
    condition     = !var.enable_memory_scaling || (var.memory_target_value >= 10 && var.memory_target_value <= 90)
    error_message = "memory_target_value deve estar entre 10 e 90 quando o scaling por memória estiver habilitado."
  }
}

variable "enable_alb_scaling" {
  description = "Habilita a policy de Target Tracking baseada em RequestCountPerTarget do ALB."
  type        = bool
  default     = false
}

variable "alb_load_balancer_arn_suffix" {
  description = "ARN suffix do Application Load Balancer no formato app/<name>/<id>."
  type        = string
  default     = null

  validation {
    condition     = !var.enable_alb_scaling || length(trimspace(coalesce(var.alb_load_balancer_arn_suffix, ""))) > 0
    error_message = "alb_load_balancer_arn_suffix deve ser informado (não pode ser nulo ou vazio) quando enable_alb_scaling for true."
  }
}

variable "alb_target_group_arn_suffix" {
  description = "ARN suffix do Target Group associado ao ALB no formato targetgroup/<name>/<id>."
  type        = string
  default     = null

  validation {
    condition     = !var.enable_alb_scaling || length(trimspace(coalesce(var.alb_target_group_arn_suffix, ""))) > 0
    error_message = "alb_target_group_arn_suffix deve ser informado (não pode ser nulo ou vazio) quando enable_alb_scaling for true."
  }
}

variable "alb_request_count_target_value" {
  description = "Valor alvo de requests por target (RequestCountPerTarget) para o ALB."
  type        = number
  default     = 100
}

variable "scale_in_cooldown" {
  description = "Tempo (segundos) de espera antes de permitir novo scale-in."
  type        = number
  default     = 120

  validation {
    condition     = var.scale_in_cooldown >= 0
    error_message = "scale_in_cooldown deve ser maior ou igual a zero."
  }
}

variable "scale_out_cooldown" {
  description = "Tempo (segundos) de espera antes de permitir novo scale-out."
  type        = number
  default     = 60

  validation {
    condition     = var.scale_out_cooldown >= 0
    error_message = "scale_out_cooldown deve ser maior ou igual a zero."
  }
}

variable "disable_scale_in" {
  description = "Se true, impede ações de scale-in (redução) nos policies de Target Tracking."
  type        = bool
  default     = false
}

# =============================================================================
# Scheduled Scaling (Cost Optimization)
# =============================================================================

variable "enable_scheduled_scaling" {
  description = "Habilita scheduled scaling para reduzir custos fora do horário comercial."
  type        = bool
  default     = false
}

variable "schedule_timezone" {
  description = "Timezone para os schedules (ex: America/Sao_Paulo)."
  type        = string
  default     = "America/Sao_Paulo"
}

variable "scale_down_schedule" {
  description = "Expressão cron para scale down (ex: cron(0 18 ? * MON-FRI *) = 18h seg-sex)."
  type        = string
  default     = "cron(0 18 ? * MON-FRI *)"

  validation {
    condition     = can(regex("^(cron|rate)\\(.*\\)$", var.scale_down_schedule))
    error_message = "scale_down_schedule deve ser uma expressão cron ou rate válida (ex: cron(0 18 ? * MON-FRI *))."
  }
}

variable "scale_up_schedule" {
  description = "Expressão cron para scale up (ex: cron(0 8 ? * MON-FRI *) = 8h seg-sex)."
  type        = string
  default     = "cron(0 8 ? * MON-FRI *)"

  validation {
    condition     = can(regex("^(cron|rate)\\(.*\\)$", var.scale_up_schedule))
    error_message = "scale_up_schedule deve ser uma expressão cron ou rate válida (ex: cron(0 8 ? * MON-FRI *))."
  }
}

variable "scale_down_min_capacity" {
  description = "Capacidade mínima durante o período de scale down (0 para desligar completamente)."
  type        = number
  default     = 0

  validation {
    condition     = var.scale_down_min_capacity >= 0
    error_message = "scale_down_min_capacity deve ser maior ou igual a zero."
  }
}

variable "scale_down_max_capacity" {
  description = "Capacidade máxima durante o período de scale down."
  type        = number
  default     = 0

  validation {
    condition     = var.scale_down_max_capacity >= 0
    error_message = "scale_down_max_capacity deve ser maior ou igual a zero."
  }
}

# =============================================================================
# Tags
# =============================================================================

variable "tags" {
  description = "Mapa de tags adicionais para consistência com outros módulos (App Auto Scaling não aplica tags atualmente)."
  type        = map(string)
  default     = {}
}
