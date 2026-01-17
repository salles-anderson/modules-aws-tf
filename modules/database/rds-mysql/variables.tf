variable "project_name" {
  description = "Nome do projeto para taguear os recursos de forma consistente."
  type        = string
}

variable "identifier" {
  description = "O identificador da instância de banco de dados. Deve ser único na sua conta AWS."
  type        = string
}

# --- Configuração da Instância ---
variable "instance_class" {
  description = "A classe de instância para o banco de dados (ex: db.t3.micro)."
  type        = string
}

variable "allocated_storage" {
  description = "A quantidade de armazenamento alocada (em GB)."
  type        = number
}

variable "storage_type" {
  description = "O tipo de armazenamento (ex: gp2, io1)."
  type        = string
  default     = "gp2"
}

variable "storage_encrypted" {
  description = "Se o armazenamento da instância deve ser criptografado."
  type        = bool
  default     = true
}

variable "engine_version" {
  description = "A versão do engine MySQL."
  type        = string
  default     = "8.0.35"
}

variable "multi_az" {
  description = "Se a instância deve ser implantada em múltiplas AZs para alta disponibilidade."
  type        = bool
  default     = true
}

variable "publicly_accessible" {
  description = "Se a instância deve ser acessível publicamente. Recomenda-se `false` para produção."
  type        = bool
  default     = false
}

# --- Configuração do Banco ---
variable "db_name" {
  description = "O nome do banco de dados inicial a ser criado."
  type        = string
}

variable "username" {
  description = "O nome de usuário mestre para o banco de dados."
  type        = string
}

variable "password" {
  description = "A senha para o usuário mestre. Deve ser tratada como 'sensitive'."
  type        = string
  sensitive   = true
}

# --- Configuração de Rede e Segurança ---
variable "subnet_ids" {
  description = "Lista de IDs de sub-redes para o DB Subnet Group."
  type        = list(string)
}

variable "vpc_security_group_ids" {
  description = "Lista de IDs de Security Groups para associar à instância."
  type        = list(string)
}

# --- Configuração Adicional ---
variable "parameter_group_name" {
  description = "O nome do DB Parameter Group a ser associado."
  type        = string
  default     = null
}

variable "backup_retention_period" {
  description = "O número de dias para reter backups automáticos."
  type        = number
  default     = 7
}

variable "skip_final_snapshot" {
  description = "Se um snapshot final deve ser pulado ao deletar a instância. `false` é recomendado para produção."
  type        = bool
  default     = false
}

variable "skip_final_snapshot_timestamp" {
  description = "Se um snapshot final deve ser pulado ao deletar a instância. `false` é recomendado para produção."
  type        = string
  default     = false
}

variable "tags" {
  description = "Um mapa de tags customizadas para adicionar aos recursos."
  type        = map(string)
  default     = {}
}
