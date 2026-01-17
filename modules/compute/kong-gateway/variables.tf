# =============================================================================
# Kong Gateway Module - Variables
# =============================================================================

variable "name_prefix" {
  description = "Prefixo para nomenclatura dos recursos (ex: project-env)."
  type        = string
}

variable "tags" {
  description = "Tags aplicadas a todos os recursos."
  type        = map(string)
  default     = {}
}

# =============================================================================
# Networking
# =============================================================================

variable "vpc_id" {
  description = "ID da VPC onde o Kong será deployado."
  type        = string
}

variable "subnet_ids" {
  description = "IDs das subnets privadas para o ECS Service."
  type        = list(string)
}

variable "aws_region" {
  description = "Região AWS."
  type        = string
}

variable "alb_security_group_id" {
  description = "ID do Security Group do ALB (para permitir ingress no Kong)."
  type        = string
}

variable "backend_security_group_id" {
  description = "ID do Security Group do backend API (para permitir Kong -> API)."
  type        = string
}

# =============================================================================
# Backend Configuration (Critical: How Kong reaches the backend)
# =============================================================================

variable "backend_host" {
  description = "Hostname/DNS do backend (ex: alb-internal.amazonaws.com ou api.service.local)."
  type        = string
}

variable "backend_port" {
  description = "Porta do backend API."
  type        = number
  default     = 3000
}

variable "backend_protocol" {
  description = "Protocolo para comunicação com backend (http ou https)."
  type        = string
  default     = "http"

  validation {
    condition     = contains(["http", "https"], var.backend_protocol)
    error_message = "backend_protocol deve ser 'http' ou 'https'."
  }
}

variable "backend_path_prefix" {
  description = "Prefixo de path para adicionar nas requisições ao backend."
  type        = string
  default     = ""
}

# =============================================================================
# ALB Integration
# =============================================================================

variable "listener_arn" {
  description = "ARN do listener HTTPS do ALB."
  type        = string
}

variable "listener_rule_priority" {
  description = "Prioridade da regra do listener (menor = maior precedência)."
  type        = number
  default     = 100
}

variable "routing_paths" {
  description = "Path patterns para rotear para o Kong."
  type        = list(string)
  default     = ["/api", "/api/*"]
}

variable "health_check_path" {
  description = "Path do health check do Kong."
  type        = string
  default     = "/status"
}

# =============================================================================
# ECS Configuration
# =============================================================================

variable "ecs_cluster_arn" {
  description = "ARN do cluster ECS."
  type        = string
}

variable "execution_role_arn" {
  description = "ARN da IAM Role de execução do ECS."
  type        = string
}

variable "task_role_arn" {
  description = "ARN da IAM Role da task ECS."
  type        = string
}

variable "desired_count" {
  description = "Número desejado de tasks."
  type        = number
  default     = 1
}

variable "kong_cpu" {
  description = "CPU da task (Fargate units)."
  type        = number
  default     = 256
}

variable "kong_memory" {
  description = "Memória da task em MiB."
  type        = number
  default     = 512
}

variable "assign_public_ip" {
  description = "Atribuir IP público às tasks."
  type        = bool
  default     = false
}

variable "enable_execute_command" {
  description = "Habilitar ECS Exec para debug."
  type        = bool
  default     = true
}

# =============================================================================
# Kong Configuration
# =============================================================================

variable "kong_image" {
  description = "Imagem Docker do Kong."
  type        = string
  default     = "kong:3.6-alpine"
}

variable "kong_proxy_port" {
  description = "Porta do proxy Kong (HTTP)."
  type        = number
  default     = 8000
}

variable "kong_admin_port" {
  description = "Porta da Admin API do Kong."
  type        = number
  default     = 8001
}

variable "kong_log_level" {
  description = "Nível de log do Kong (debug, info, notice, warn, error, crit)."
  type        = string
  default     = "info"

  validation {
    condition     = contains(["debug", "info", "notice", "warn", "error", "crit"], var.kong_log_level)
    error_message = "kong_log_level deve ser: debug, info, notice, warn, error ou crit."
  }
}

variable "kong_plugins" {
  description = "Lista de plugins bundled para habilitar."
  type        = string
  default     = "bundled"
}

variable "kong_extra_env" {
  description = "Variáveis de ambiente extras para o container Kong."
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "kong_custom_config" {
  description = "Configuração declarativa customizada do Kong em YAML (override da config gerada automaticamente)."
  type        = string
  default     = null
}

# =============================================================================
# Redis Integration (Rate Limiting)
# =============================================================================

variable "enable_redis" {
  description = "Habilitar integração com Redis para rate limiting."
  type        = bool
  default     = false
}

variable "redis_endpoint" {
  description = "Endpoint do Redis."
  type        = string
  default     = null
}

variable "redis_port" {
  description = "Porta do Redis."
  type        = number
  default     = 6379
}

variable "redis_ssl" {
  description = "Usar SSL para conexão com Redis."
  type        = bool
  default     = true
}

variable "redis_security_group_id" {
  description = "ID do Security Group do Redis (para permitir Kong -> Redis)."
  type        = string
  default     = null
}

# =============================================================================
# Logging
# =============================================================================

variable "log_retention_days" {
  description = "Retenção dos logs em dias."
  type        = number
  default     = 7
}

# =============================================================================
# Auto Scaling
# =============================================================================

variable "enable_autoscaling" {
  description = "Habilitar Auto Scaling para o Kong."
  type        = bool
  default     = false
}

variable "min_capacity" {
  description = "Capacidade mínima do Auto Scaling."
  type        = number
  default     = 1
}

variable "max_capacity" {
  description = "Capacidade máxima do Auto Scaling."
  type        = number
  default     = 3
}

variable "cpu_target" {
  description = "Target de CPU (%) para scaling."
  type        = number
  default     = 70
}

variable "memory_target" {
  description = "Target de memória (%) para scaling."
  type        = number
  default     = 80
}
