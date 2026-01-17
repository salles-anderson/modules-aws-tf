variable "project_name" {
  description = "Identificador do projeto utilizado para compor tags."
  type        = string
}

variable "lambda_function_name" {
  description = "Nome da função Lambda."
  type        = string
}

variable "lambda_description" {
  description = "Descrição da função Lambda."
  type        = string
  default     = null
}

variable "lambda_runtime" {
  description = "Runtime da função Lambda (ex: nodejs20.x)."
  type        = string
  default     = "nodejs20.x"
}

variable "lambda_handler" {
  description = "Handler configurado para a função."
  type        = string
  default     = "index.handler"
}

variable "lambda_timeout" {
  description = "Tempo máximo de execução em segundos."
  type        = number
  default     = 30
}

variable "lambda_memory_size" {
  description = "Memória (MB) alocada para a função."
  type        = number
  default     = 256
}

variable "publish_lambda_version" {
  description = "Se verdadeiro, publica nova versão a cada alteração."
  type        = bool
  default     = false
}

variable "lambda_architectures" {
  description = "Arquiteturas suportadas pela função."
  type        = list(string)
  default     = ["x86_64"]
}

variable "lambda_layers" {
  description = "Lista de ARNs de layers anexados à função."
  type        = list(string)
  default     = []
}

variable "lambda_kms_key_arn" {
  description = "ARN da chave KMS utilizada para criptografar variáveis de ambiente."
  type        = string
  default     = null
}

variable "lambda_role_name" {
  description = "Nome customizado para a IAM Role da Lambda."
  type        = string
  default     = null
}

variable "additional_environment_variables" {
  description = "Variáveis de ambiente adicionais para a Lambda."
  type        = map(string)
  default     = {}
}

variable "api_url" {
  description = "URL chamada pela função Lambda."
  type        = string
}

variable "api_secret_name" {
  description = "Nome (ou ARN) do segredo no Secrets Manager utilizado pela função."
  type        = string
  default     = null
}

variable "lambda_source_dir" {
  description = "Diretório cujo conteúdo será zipado e enviado. Quando nulo, usa ./src."
  type        = string
  default     = null
}

variable "lambda_package_s3_bucket" {
  description = "Bucket S3 com o pacote ZIP já publicado."
  type        = string
  default     = null
}

variable "lambda_package_s3_key" {
  description = "Chave do objeto S3 com o pacote ZIP."
  type        = string
  default     = null
}

variable "lambda_package_s3_object_version" {
  description = "Versão do objeto S3 (quando aplicável)."
  type        = string
  default     = null
}

variable "lambda_source_code_hash" {
  description = "Hash base64 do pacote externo em S3."
  type        = string
  default     = null
}

variable "environment_variables" {
  description = "Mapa de variáveis de ambiente."
  type        = map(string)
  default     = {}
}

variable "lambda_vpc_id" {
  description = "ID da VPC para associar a Lambda."
  type        = string
  default     = null
}

variable "lambda_subnet_ids" {
  description = "IDs das subnets onde a Lambda será executada."
  type        = list(string)
  default     = []
}

variable "lambda_security_group_ids" {
  description = "Security groups adicionais para a Lambda."
  type        = list(string)
  default     = []
}

variable "lambda_security_group_name" {
  description = "Nome do security group criado automaticamente."
  type        = string
  default     = null
}

variable "create_log_group" {
  description = "Se verdadeiro, cria o CloudWatch Log Group."
  type        = bool
  default     = true
}

variable "log_retention_in_days" {
  description = "Tempo de retenção dos logs."
  type        = number
  default     = 30
}

variable "cloudwatch_logs_kms_key_id" {
  description = "ARN da chave KMS para criptografar logs."
  type        = string
  default     = null
}

variable "tags" {
  description = "Mapa de tags adicionais."
  type        = map(string)
  default     = {}
}
