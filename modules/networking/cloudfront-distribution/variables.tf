variable "project_name" {
  description = "Nome do projeto para taguear recursos."
  type        = string
}

variable "distribution_comment" {
  description = "Comentário/nome amigável da distribuição."
  type        = string
}

variable "enabled" {
  description = "Habilita a distribuição."
  type        = bool
  default     = true
}

variable "price_class" {
  description = "Price class (ex.: PriceClass_100, PriceClass_200, PriceClass_All)."
  type        = string
  default     = "PriceClass_100"
}

variable "aliases" {
  description = "Lista de domínios alternativos (CNAMEs)."
  type        = list(string)
  default     = []
}

variable "default_root_object" {
  description = "Objeto padrão."
  type        = string
  default     = "index.html"
}

variable "is_ipv6_enabled" {
  description = "Habilita IPv6."
  type        = bool
  default     = true
}

variable "origin_domain_name" {
  description = "Domínio da origem (S3 ou custom)."
  type        = string
}

variable "origin_id" {
  description = "ID da origem."
  type        = string
}

variable "origin_path" {
  description = "Prefixo opcional no caminho da origem."
  type        = string
  default     = ""
}

variable "origin_is_s3" {
  description = "Define se a origem é S3. Caso falso, usa custom_origin_config."
  type        = bool
  default     = true
}

variable "create_origin_access_identity" {
  description = "Cria uma Origin Access Identity para S3."
  type        = bool
  default     = true
}

variable "origin_access_identity" {
  description = "OAI existente a ser usada (cloudfront_access_identity_path)."
  type        = string
  default     = null
}

variable "oai_comment" {
  description = "Comentário para OAI criada."
  type        = string
  default     = "Managed by Terraform"
}

variable "custom_origin_http_port" {
  description = "Porta HTTP da origem custom."
  type        = number
  default     = 80
}

variable "custom_origin_https_port" {
  description = "Porta HTTPS da origem custom."
  type        = number
  default     = 443
}

variable "origin_protocol_policy" {
  description = "Política de protocolo para origem custom (http-only, https-only, match-viewer)."
  type        = string
  default     = "https-only"
}

variable "origin_ssl_protocols" {
  description = "Protocolos SSL permitidos na origem custom."
  type        = list(string)
  default     = ["TLSv1.2"]
}

variable "allowed_methods" {
  description = "Métodos permitidos."
  type        = list(string)
  default     = ["GET", "HEAD", "OPTIONS"]
}

variable "cached_methods" {
  description = "Métodos em cache."
  type        = list(string)
  default     = ["GET", "HEAD"]
}

variable "viewer_protocol_policy" {
  description = "Política de protocolo do viewer (ex.: redirect-to-https)."
  type        = string
  default     = "redirect-to-https"
}

variable "cache_policy_id" {
  description = "ID da cache policy. Quando nulo, usa padrão do CloudFront."
  type        = string
  default     = null
}

variable "origin_request_policy_id" {
  description = "ID da origin request policy."
  type        = string
  default     = null
}

variable "lambda_function_associations" {
  description = "Associações de Lambda@Edge."
  type = list(object({
    event_type   = string
    lambda_arn   = string
    include_body = optional(bool)
  }))
  default = []
}

variable "logging_bucket" {
  description = "Bucket (em formato <bucket>.s3.amazonaws.com) para logs de acesso."
  type        = string
  default     = null
}

variable "logging_include_cookies" {
  description = "Inclui cookies nos logs."
  type        = bool
  default     = false
}

variable "logging_prefix" {
  description = "Prefixo para logs."
  type        = string
  default     = null
}

variable "acm_certificate_arn" {
  description = "ARN do certificado ACM (us-east-1 para CloudFront)."
  type        = string
  default     = null
}

variable "web_acl_id" {
  description = "ARN do Web ACL do WAF."
  type        = string
  default     = null
}

variable "tags" {
  description = "Mapa de tags adicionais."
  type        = map(string)
  default     = {}
}
