variable "project_name" {
  description = "Nome do projeto para tags padrão."
  type        = string
}

variable "name" {
  description = "Nome lógico do Distribution para comentários e tag Name."
  type        = string
}

variable "comment" {
  description = "Comentário opcional exibido no console do CloudFront. Usa `name` por padrão."
  type        = string
  default     = null
}

variable "enabled" {
  description = "Quando `false`, a distribuição é criada desabilitada."
  type        = bool
  default     = true
}

variable "aliases" {
  description = "Lista de domínios (CNAMEs) adicionais."
  type        = list(string)
  default     = []
}

variable "default_root_object" {
  description = "Objeto padrão retornado quando o caminho é vazio."
  type        = string
  default     = null
}

variable "http_version" {
  description = "Versão do HTTP suportada (por exemplo `http2`, `http2and3`)."
  type        = string
  default     = "http2and3"
}

variable "is_ipv6_enabled" {
  description = "Habilita suporte IPv6."
  type        = bool
  default     = true
}

variable "price_class" {
  description = "Classe de preço da distribuição."
  type        = string
  default     = "PriceClass_All"
}

variable "web_acl_id" {
  description = "ID/ARN do WAF associado à distribuição."
  type        = string
  default     = null
}

variable "wait_for_deployment" {
  description = "Controla se o Terraform deve aguardar a distribuição ficar ativa."
  type        = bool
  default     = true
}

variable "origins" {
  description = "Mapa de origens disponíveis para os comportamentos."
  type = map(object({
    domain_name         = string
    origin_id           = optional(string)
    origin_path         = optional(string)
    connection_attempts = optional(number)
    connection_timeout  = optional(number)
    custom_headers      = optional(map(string))
    s3_origin_config = optional(object({
      origin_access_identity = optional(string)
    }))
    custom_origin_config = optional(object({
      http_port                = number
      https_port               = number
      origin_protocol_policy   = string
      origin_ssl_protocols     = list(string)
      origin_keepalive_timeout = optional(number)
      origin_read_timeout      = optional(number)
    }))
    origin_shield = optional(object({
      enabled              = optional(bool)
      origin_shield_region = string
    }))
  }))
  default = {}
}

variable "default_cache_behavior" {
  description = "Configuração do cache behavior padrão exigido pelo CloudFront."
  type = object({
    target_origin_id       = string
    viewer_protocol_policy = string
    allowed_methods        = list(string)
    cached_methods         = list(string)
    compress               = optional(bool)
    query_string           = optional(bool)
    forwarded_headers      = optional(list(string))
    cookies_forward        = optional(string)
    cookies_whitelist      = optional(list(string))
    min_ttl                = optional(number)
    default_ttl            = optional(number)
    max_ttl                = optional(number)
    lambda_function_associations = optional(list(object({
      event_type   = string
      lambda_arn   = string
      include_body = optional(bool)
    })))
  })
}

variable "ordered_cache_behaviors" {
  description = "Lista de comportamentos adicionais (cache behaviors) aplicados em ordem."
  type = list(object({
    path_pattern           = string
    target_origin_id       = string
    viewer_protocol_policy = string
    allowed_methods        = list(string)
    cached_methods         = list(string)
    compress               = optional(bool)
    query_string           = optional(bool)
    forwarded_headers      = optional(list(string))
    cookies_forward        = optional(string)
    cookies_whitelist      = optional(list(string))
    min_ttl                = optional(number)
    default_ttl            = optional(number)
    max_ttl                = optional(number)
    lambda_function_associations = optional(list(object({
      event_type   = string
      lambda_arn   = string
      include_body = optional(bool)
    })))
  }))
  default = []
}

variable "restrictions" {
  description = "Configuração de restrições geográficas."
  type = object({
    geo_restriction = object({
      restriction_type = string
      locations        = optional(list(string))
    })
  })
  default = {
    geo_restriction = {
      restriction_type = "none"
      locations        = []
    }
  }
}

variable "viewer_certificate" {
  description = "Configuração do certificado ligado ao CloudFront."
  type = object({
    acm_certificate_arn            = optional(string)
    cloudfront_default_certificate = optional(bool)
    iam_certificate_id             = optional(string)
    minimum_protocol_version       = optional(string)
    ssl_support_method             = optional(string)
  })
  default = {
    cloudfront_default_certificate = true
    minimum_protocol_version       = "TLSv1.2_2021"
  }
}

variable "logging_config" {
  description = "Configuração opcional para habilitar Access Logs no CloudFront."
  type = object({
    bucket          = string
    prefix          = optional(string)
    include_cookies = optional(bool)
  })
  default = null
}

variable "tags" {
  description = "Mapa de tags adicionais."
  type        = map(string)
  default     = {}
}
