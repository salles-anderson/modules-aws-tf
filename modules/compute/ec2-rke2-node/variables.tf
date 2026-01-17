variable "project_name" {
  description = "Nome do projeto para tagueamento geral."
  type        = string
}

variable "cluster_name" {
  description = "Nome do cluster Kubernetes, usado para a tag 'Name' das instâncias."
  type        = string
}

variable "instance_count" {
  description = "Número de instâncias (nós) a serem criadas."
  type        = number
  default     = 1
}

variable "ami_id" {
  description = "ID da AMI a ser usada. Se não for especificado, o módulo buscará a última AMI do Ubuntu 22.04 LTS."
  type        = string
  default     = null
}

variable "instance_type" {
  description = "Tipo da instância EC2 (ex: t3.medium)."
  type        = string
}

variable "subnet_ids" {
  description = "Lista de IDs de sub-redes onde as instâncias serão distribuídas. O módulo fará a distribuição entre elas."
  type        = list(string)
}

variable "security_group_ids" {
  description = "Lista de IDs de Security Groups para associar às instâncias."
  type        = list(string)
}

variable "iam_instance_profile_name" {
  description = "Nome do IAM Instance Profile a ser associado às instâncias. Use a saída do módulo 'iam/k8s-node-role'."
  type        = string
}

variable "key_name" {
  description = "Nome do Key Pair para acesso SSH. Opcional."
  type        = string
  default     = null
}

variable "root_volume_size" {
  description = "Tamanho do volume EBS raiz em GB."
  type        = number
  default     = 50
}

# --- Configurações do RKE2 ---
variable "rke2_version" {
  description = "Versão do RKE2 a ser instalada (ex: v1.28.5+rke2r1)."
  type        = string
}

variable "rke2_role" {
  description = "Papel do nó no cluster: 'server' (control-plane) ou 'agent' (worker)."
  type        = string
  validation {
    condition     = contains(["server", "agent"], var.rke2_role)
    error_message = "O papel do RKE2 deve ser 'server' ou 'agent'."
  }
}

variable "rke2_token" {
  description = "O token de junção do cluster. Deve ser o mesmo para todos os nós do mesmo cluster."
  type        = string
  sensitive   = true
}

variable "tags" {
  description = "Um mapa de tags customizadas para adicionar às instâncias."
  type        = map(string)
  default     = {}
}