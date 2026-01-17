variable "project_name" {
  description = "Nome do projeto para compor tags."
  type        = string
}

variable "user_pool_name" {
  description = "Nome do User Pool."
  type        = string
}

variable "auto_verified_attributes" {
  description = "Atributos auto verificados (ex.: email, phone_number)."
  type        = list(string)
  default     = ["email", "phone_number"]
}

variable "mfa_configuration" {
  description = "Configuração MFA (OFF, ON, OPTIONAL)."
  type        = string
  default     = "OPTIONAL"

  validation {
    condition     = contains(["OFF", "ON", "OPTIONAL"], var.mfa_configuration)
    error_message = "mfa_configuration deve ser OFF, ON ou OPTIONAL."
  }
}

variable "enable_software_token_mfa" {
  description = "Habilita MFA via TOTP (software token / app autenticador) no User Pool."
  type        = bool
  default     = false

  validation {
    condition     = var.mfa_configuration == "OFF" || var.enable_software_token_mfa
    error_message = "Para mfa_configuration=OPTIONAL/ON, habilite enable_software_token_mfa=true (este módulo ainda não suporta SMS MFA)."
  }

  # Opcional (higiene): evita configuração incoerente
  validation {
    condition     = !(var.mfa_configuration == "OFF" && var.enable_software_token_mfa)
    error_message = "Se mfa_configuration=OFF, mantenha enable_software_token_mfa=false."
  }
}

variable "email_verification_subject" {
  description = "Assunto do e-mail de verificação."
  type        = string
  default     = "Verifique seu e-mail"
}

variable "email_verification_message" {
  description = "Mensagem do e-mail de verificação. Use {####} para o código."
  type        = string
  default     = "Seu código de verificação é {####}."
}

variable "password_min_length" {
  description = "Comprimento mínimo da senha."
  type        = number
  default     = 12
}

variable "password_require_lowercase" {
  description = "Requer minúsculas."
  type        = bool
  default     = true
}

variable "password_require_numbers" {
  description = "Requer números."
  type        = bool
  default     = true
}

variable "password_require_symbols" {
  description = "Requer símbolos."
  type        = bool
  default     = true
}

variable "password_require_uppercase" {
  description = "Requer maiúsculas."
  type        = bool
  default     = true
}

variable "temporary_password_validity_days" {
  description = "Dias de validade da senha temporária."
  type        = number
  default     = 7
}

variable "client_generate_secret" {
  description = "Gera secret para o app client."
  type        = bool
  default     = false
}

variable "client_callback_urls" {
  description = "Callback URLs para o app client."
  type        = list(string)
  default     = []
}

variable "client_logout_urls" {
  description = "Logout URLs para o app client."
  type        = list(string)
  default     = []
}

variable "client_allowed_oauth_flows" {
  description = "Fluxos OAuth permitidos (ex.: code, implicit, client_credentials)."
  type        = list(string)
  default     = []
}

variable "client_allowed_oauth_scopes" {
  description = "Escopos OAuth permitidos."
  type        = list(string)
  default     = []
}

variable "client_supported_identity_providers" {
  description = "IdPs suportados (ex.: COGNITO, Google)."
  type        = list(string)
  default     = ["COGNITO"]
}

variable "client_explicit_auth_flows" {
  description = "Fluxos explícitos permitidos."
  type        = list(string)
  default     = ["ALLOW_USER_SRP_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]
}

variable "tags" {
  description = "Mapa de tags adicionais."
  type        = map(string)
  default     = {}
}

variable "clients" {
  description = "Mapa de App Clients (multi-client). Se vazio, usa o client legado."
  type = map(object({
    name                         = string
    generate_secret              = optional(bool, false)
    callback_urls                = optional(list(string), [])
    logout_urls                  = optional(list(string), [])
    allowed_oauth_flows          = optional(list(string), [])
    allowed_oauth_scopes         = optional(list(string), [])
    supported_identity_providers = optional(list(string), ["COGNITO"])
    explicit_auth_flows          = optional(list(string), ["ALLOW_USER_SRP_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"])
  }))
  default = {}
}

variable "custom_domain" {
  description = "Custom domain do Cognito (Hosted UI) + Route53 alias."
  type = object({
    enabled         = bool
    domain_name     = string
    certificate_arn = string
    route53_zone_id = string
  })
  default = {
    enabled         = false
    domain_name     = ""
    certificate_arn = ""
    route53_zone_id = ""
  }
}

variable "user_pool_client_name" {
  description = "Nome do App Client legado (usado quando var.clients estiver vazio)."
  type        = string
  default     = null
}

variable "aws_region" {
  description = "Região AWS (ex.: us-east-1). Usada para issuer/jwks_uri."
  type        = string
}
