variable "project_name" {
  description = "Nome do projeto para compor tags."
  type        = string
}

variable "name" {
  description = "Nome do Web ACL."
  type        = string
}

variable "scope" {
  description = "Escopo do WAF (REGIONAL ou CLOUDFRONT)."
  type        = string

  validation {
    condition     = contains(["REGIONAL", "CLOUDFRONT"], var.scope)
    error_message = "scope deve ser REGIONAL ou CLOUDFRONT."
  }
}

variable "description" {
  description = "Descrição do Web ACL."
  type        = string
  default     = null
}

variable "default_action" {
  description = "Ação padrão (allow ou block)."
  type        = string
  default     = "allow"

  validation {
    condition     = contains(["allow", "block"], var.default_action)
    error_message = "default_action deve ser allow ou block."
  }
}

variable "managed_rule_groups" {
  description = "Lista de managed rule groups a habilitar."
  type = list(object({
    name           = string
    vendor_name    = string
    priority       = number
    excluded_rules = optional(list(string), [])
  }))
  default = []

  validation {
    condition = length(
      distinct(
        concat(
          [for g in var.managed_rule_groups : g.priority],
          var.enable_aws_managed_common_rules ? [var.aws_managed_common_priority] : []
        )
      )
      ) == length(
      concat(
        [for g in var.managed_rule_groups : g.priority],
        var.enable_aws_managed_common_rules ? [var.aws_managed_common_priority] : []
      )
    )

    error_message = "Prioridades das managed rules (managed_rule_groups e aws_managed_common_priority) devem ser únicas."
  }
}

variable "association_resource_arns" {
  description = "Lista de ARNs de recursos regionais (ex.: ALB/API Gateway) para associar ao Web ACL. Usado apenas quando scope=REGIONAL."
  type        = list(string)
  default     = []
}

variable "enable_logging" {
  description = "Habilita logging do Web ACL."
  type        = bool
  default     = false
}

variable "logging_destination_arn" {
  description = "ARN do destino de logging (Kinesis Firehose). Obrigatório quando enable_logging=true."
  type        = string
  default     = null

  validation {
    condition     = var.enable_logging == false || var.logging_destination_arn != null
    error_message = "logging_destination_arn é obrigatório quando enable_logging=true."
  }
}

variable "redacted_fields" {
  description = "Campos a suprimir no logging. Suporta: method, query_string, uri_path, body, all_query_arguments, single_header, single_query_argument."
  type = list(object({
    type = string
    data = optional(string)
  }))
  default = []

  validation {
    condition     = length(var.redacted_fields) == 0 || alltrue([for f in var.redacted_fields : contains(["method", "query_string", "uri_path", "body", "all_query_arguments", "single_header", "single_query_argument"], lower(f.type))])
    error_message = "redacted_fields.type deve ser um dos: method, query_string, uri_path, body, all_query_arguments, single_header, single_query_argument."
  }

  validation {
    condition     = length([for f in var.redacted_fields : f if contains(["single_header", "single_query_argument"], lower(f.type)) && try(f.data, null) == null]) == 0
    error_message = "redacted_fields.data é obrigatório quando type é single_header ou single_query_argument."
  }
}

variable "enable_rate_limit" {
  description = "Habilita regra rate-based."
  type        = bool
  default     = false
}

variable "rate_limit" {
  description = "Limite de requisições para a regra rate-based."
  type        = number
  default     = 2000
}

variable "rate_aggregate_key_type" {
  description = "Chave de agregação da regra rate-based (IP ou FORWARDED_IP)."
  type        = string
  default     = "IP"

  validation {
    condition     = contains(["IP", "FORWARDED_IP"], var.rate_aggregate_key_type)
    error_message = "rate_aggregate_key_type deve ser IP ou FORWARDED_IP."
  }
}

variable "rate_forwarded_ip_config" {
  description = "Configuração para FORWARDED_IP (header_name, fallback_behavior). Necessária quando rate_aggregate_key_type=FORWARDED_IP."
  type = object({
    header_name       = string
    fallback_behavior = string
  })
  default = null
}

variable "rate_priority" {
  description = "Prioridade da regra rate-based."
  type        = number
  default     = 10
}

variable "rate_action" {
  description = "Ação da regra rate-based (block ou count)."
  type        = string
  default     = "block"

  validation {
    condition     = contains(["block", "count"], var.rate_action)
    error_message = "rate_action deve ser block ou count."
  }

  validation {
    condition = !var.enable_rate_limit || (
      var.rate_limit > 0 &&
      contains(["IP", "FORWARDED_IP"], var.rate_aggregate_key_type) &&
      contains(["block", "count"], var.rate_action) &&
      (var.rate_aggregate_key_type != "FORWARDED_IP" || (
        var.rate_forwarded_ip_config != null &&
        contains(["MATCH", "NO_MATCH"], var.rate_forwarded_ip_config.fallback_behavior)
      ))
    )

    error_message = "Para rate limit: rate_limit deve ser > 0; rate_aggregate_key_type deve ser IP ou FORWARDED_IP; rate_action deve ser block ou count; para FORWARDED_IP configure rate_forwarded_ip_config (fallback_behavior MATCH ou NO_MATCH)."
  }
}

variable "enable_aws_managed_common_rules" {
  description = "Habilita o conjunto AWSManagedRulesCommonRuleSet automaticamente."
  type        = bool
  default     = false
}

variable "aws_managed_common_priority" {
  description = "Prioridade para a regra AWSManagedRulesCommonRuleSet."
  type        = number
  default     = 1
}

variable "cloudwatch_metrics_enabled" {
  description = "Habilita métricas do CloudWatch no Web ACL."
  type        = bool
  default     = true
}

variable "sampled_requests_enabled" {
  description = "Habilita sampled requests no Web ACL."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Mapa de tags adicionais."
  type        = map(string)
  default     = {}
}
