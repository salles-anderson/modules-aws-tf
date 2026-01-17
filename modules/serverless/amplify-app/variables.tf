variable "project_name" {
  description = "Nome do projeto para taguear recursos."
  type        = string
}

variable "app_name" {
  description = "Nome da aplicação Amplify."
  type        = string
}

variable "repository" {
  description = "Repositório Git conectado (ex.: https://github.com/org/repo)."
  type        = string
  default     = null
}

variable "oauth_token" {
  description = "Token OAuth (PAT) para acesso ao repositorio. Quando null, a conexao pode ser feita no Console."
  type        = string
  default     = null
  sensitive   = true
}

variable "access_token" {
  description = "Access token para acesso ao repositório"
  type        = string
  default     = null
  sensitive   = true
}

variable "iam_service_role_arn" {
  description = "ARN da IAM Role usada pelo Amplify."
  type        = string
  default     = null
}

variable "platform" {
  description = "Plataforma alvo (ex.: WEB)."
  type        = string
  default     = "WEB"
}

variable "enable_auto_branch_creation" {
  description = "Habilita criação automática de branches."
  type        = bool
  default     = false
}

variable "auto_branch_creation_patterns" {
  description = "Padrões de branches para criação automática."
  type        = list(string)
  default     = ["*"]
}

variable "create_branch" {
  description = "Cria uma branch específica no Amplify."
  type        = bool
  default     = false
}

variable "branch_name" {
  description = "Nome da branch a ser criada."
  type        = string
  default     = "develop"
}

variable "branch_stage" {
  description = "Stage da branch (ex.: DEVELOPMENT)."
  type        = string
  default     = "DEVELOPMENT"
}

variable "build_spec" {
  description = "Buildspec customizado em YAML."
  type        = string
  default     = null
}

variable "basic_auth_credentials" {
  description = "Credenciais de basic auth (username:password)."
  type        = string
  default     = null
  sensitive   = true
}

variable "custom_rules" {
  description = "Regras de redirecionamento do Amplify."
  type = list(object({
    source    = string
    target    = string
    status    = string
    condition = optional(string)
  }))
  default = []
}

variable "environment_variables" {
  description = "Mapa de variáveis de ambiente para o app."
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Mapa de tags adicionais."
  type        = map(string)
  default     = {}
}
