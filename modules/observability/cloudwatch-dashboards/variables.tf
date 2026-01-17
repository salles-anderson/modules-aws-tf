variable "project_name" {
  description = "Nome do projeto para tagueamento de recursos."
  type        = string
}

variable "aws_region" {
  description = "Região AWS para os widgets do dashboard."
  type        = string
}

# =============================================================================
# Custom Dashboards
# =============================================================================

variable "dashboards" {
  description = "Mapa de dashboards customizados. Cada entrada deve conter 'body' com o JSON do dashboard."
  type = map(object({
    body = string
  }))
  default = {}
}

# =============================================================================
# ECS Dashboards
# =============================================================================

variable "ecs_dashboards" {
  description = "Mapa de dashboards ECS pré-construídos. Cada entrada deve conter 'cluster_name' e 'service_names'."
  type = map(object({
    cluster_name  = string
    service_names = list(string)
  }))
  default = {}
}

# =============================================================================
# RDS Dashboards
# =============================================================================

variable "rds_dashboards" {
  description = "Mapa de dashboards RDS pré-construídos. Cada entrada deve conter 'db_instance_identifier'."
  type = map(object({
    db_instance_identifier = string
  }))
  default = {}
}

# =============================================================================
# Lambda Dashboards
# =============================================================================

variable "lambda_dashboards" {
  description = "Mapa de dashboards Lambda pré-construídos. Cada entrada deve conter 'function_names'."
  type = map(object({
    function_names = list(string)
  }))
  default = {}
}

# =============================================================================
# ALB Dashboards
# =============================================================================

variable "alb_dashboards" {
  description = "Mapa de dashboards ALB pré-construídos. Cada entrada deve conter 'load_balancer_arn_suffix' e 'target_group_arn_suffix'."
  type = map(object({
    load_balancer_arn_suffix = string
    target_group_arn_suffix  = string
  }))
  default = {}
}

# =============================================================================
# Overview Dashboard
# =============================================================================

variable "create_overview_dashboard" {
  description = "Criar dashboard consolidado de visão geral."
  type        = bool
  default     = false
}

variable "overview_dashboard_name" {
  description = "Nome do dashboard de visão geral. Se não fornecido, será usado '{project_name}-overview'."
  type        = string
  default     = null
}

variable "overview_ecs_clusters" {
  description = "Lista de clusters ECS para incluir no dashboard de visão geral."
  type = list(object({
    cluster_name = string
    service_name = string
  }))
  default = []
}

variable "overview_rds_instances" {
  description = "Lista de identificadores de instâncias RDS para incluir no dashboard de visão geral."
  type        = list(string)
  default     = []
}

variable "overview_lambda_functions" {
  description = "Lista de nomes de funções Lambda para incluir no dashboard de visão geral."
  type        = list(string)
  default     = []
}

variable "overview_alb_arns" {
  description = "Lista de ARN suffixes de ALBs para incluir no dashboard de visão geral."
  type        = list(string)
  default     = []
}

# =============================================================================
# Tags
# =============================================================================

variable "tags" {
  description = "Tags adicionais a serem aplicadas em todos os recursos."
  type        = map(string)
  default     = {}
}
