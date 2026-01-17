# Touched to include in patch
variable "project_name" {
  description = "Nome do projeto para taguear os recursos."
  type        = string
}

# --- Controle de Criação ---
variable "create_vpc" {
  description = "Se `true`, o módulo criará uma nova VPC. Se `false`, usará uma VPC existente definida em `vpc_id_existing`."
  type        = bool
  default     = true
}

variable "vpc_id_existing" {
  description = "O ID de uma VPC existente para usar quando `create_vpc` for `false`."
  type        = string
  default     = null
}

# --- Configurações da VPC (usado apenas se create_vpc = true) ---
variable "vpc_cidr" {
  description = "Bloco de IPs para a nova VPC (ex: 10.10.0.0/16). Usado apenas se `create_vpc` for `true`."
  type        = string
  default     = "10.0.0.0/16"

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "vpc_cidr must be a valid CIDR block."
  }
}

variable "environment" {
  description = "Ambiente do projeto (dev, staging, prod)."
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "homolog", "staging", "prod"], var.environment)
    error_message = "O environment deve ser dev, homolog, staging ou prod."
  }
}

variable "azs" {
  description = "Lista de Zonas de Disponibilidade para criar as sub-redes. Usado apenas se `create_vpc` for `true`."
  type        = list(string)
  default     = []
}

variable "public_subnets" {
  description = "Lista de blocos CIDR para as sub-redes públicas. Usado apenas se `create_vpc` for `true`."
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for subnet in var.public_subnets : can(cidrhost(subnet, 0))
    ])
    error_message = "All public_subnets must be valid CIDR blocks."
  }
}

variable "private_subnets" {
  description = "Lista de blocos CIDR para as sub-redes privadas. Usado apenas se `create_vpc` for `true`."
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for subnet in var.private_subnets : can(cidrhost(subnet, 0))
    ])
    error_message = "All private_subnets must be valid CIDR blocks."
  }
}

variable "enable_nat_gateway" {
  description = "Se true, cria um NAT Gateway para as sub-redes privadas. Usado apenas se `create_vpc` for `true`."
  type        = bool
  default     = false
}

variable "enable_flow_logs" {
  description = "Se true, ativa os Flow Logs para a VPC. Funciona tanto para VPCs criadas quanto existentes."
  type        = bool
  default     = false
}

variable "flow_logs_retention_in_days" {
  description = "Por quantos dias os logs de fluxo da VPC devem ser mantidos no CloudWatch."
  type        = number
  default     = 7
}

variable "tags" {
  description = "Um mapa de tags para adicionar a todos os recursos criados."
  type        = map(string)
  default     = {}
}

# --- Busca de Sub-redes (usado apenas se create_vpc = false) ---
variable "private_subnet_tags_existing" {
  description = "Um mapa de tags para encontrar as sub-redes privadas existentes. Usado apenas se `create_vpc` for `false`."
  type        = map(string)
  default     = {}
}

variable "public_subnet_tags_existing" {
  description = "Um mapa de tags para encontrar as sub-redes públicas existentes. Usado apenas se `create_vpc` for `false`."
  type        = map(string)
  default     = {}
}

# --- VPC Endpoint Configuration ---
variable "enable_vpc_endpoints" {
  description = "Enable VPC Endpoints for ECR, S3, and SSM"
  type        = bool
  default     = true
}

variable "vpc_endpoint_security_group_ids" {
  description = "Security Group IDs to attach to Interface VPC Endpoints"
  type        = list(string)
  default     = []
}

variable "vpc_endpoints" {
  description = "Mapa declarativo para escolher quais VPCEs criar"
  type = map(object({
    enabled             = optional(bool, true)
    type                = optional(string, "Interface") # Gateway | Interface
    service             = string
    service_name        = optional(string)
    private_dns_enabled = optional(bool, true)
    route_table_ids     = optional(list(string))
    subnet_ids          = optional(list(string))
    security_group_ids  = optional(list(string))
    tags                = optional(map(string), {})
  }))
  default = {}
}
