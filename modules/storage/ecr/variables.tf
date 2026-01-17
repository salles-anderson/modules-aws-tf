variable "name" {
  description = "Nome do repositório ECR."
  type        = string
}

variable "image_tag_mutability" {
  description = "Define se tags podem ser sobrescritas (`MUTABLE`) ou são imutáveis (`IMMUTABLE`)."
  type        = string
  default     = "IMMUTABLE"

  validation {
    condition     = contains(["MUTABLE", "IMMUTABLE"], var.image_tag_mutability)
    error_message = "image_tag_mutability deve ser `MUTABLE` ou `IMMUTABLE`."
  }
}

variable "scan_on_push" {
  description = "Habilita escaneamento automático de imagens para vulnerabilidades ao realizar push."
  type        = bool
  default     = true
}

variable "encryption_type" {
  description = "Tipo de criptografia para a imagem armazenada (AES256 ou KMS)."
  type        = string
  default     = "AES256"

  validation {
    condition     = contains(["AES256", "KMS"], var.encryption_type)
    error_message = "encryption_type deve ser `AES256` ou `KMS`."
  }
}

variable "kms_key_arn" {
  description = "ARN da chave KMS usada quando `encryption_type` for `KMS`."
  type        = string
  default     = null

  validation {
    condition     = var.encryption_type != "KMS" || var.kms_key_arn != null
    error_message = "Ao usar encryption_type = \"KMS\" é obrigatório informar `kms_key_arn`."
  }
}

variable "force_delete" {
  description = "Se `true`, permite deletar o repositório mesmo com imagens existentes."
  type        = bool
  default     = false
}

variable "lifecycle_rules" {
  description = "Regras opcionais para expirar/priorizar imagens no repositório."
  type = list(object({
    priority    = number
    description = optional(string)
    selection = object({
      tag_status   = string
      tag_prefixes = optional(list(string))
      count_type   = string
      count_number = number
      count_unit   = optional(string)
    })
    action = object({
      type = string
    })
  }))
  default = []
}

variable "repository_policy_json" {
  description = "Documento JSON opcional para anexar como política do repositório (deve ser válido)."
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags adicionais aplicadas ao repositório."
  type        = map(string)
  default     = {}
}
