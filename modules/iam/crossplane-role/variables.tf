variable "project_name" {
  description = "Nome do projeto para taguear os recursos e dar nome à role."
  type        = string
}

variable "cluster_oidc_provider_arn" {
  description = "O ARN do provedor OIDC do cluster Kubernetes (ex: arn:aws:iam::ACCOUNT_ID:oidc-provider/oidc.eks.REGION.amazonaws.com/id/CLUSTER_ID)."
  type        = string
}

variable "cluster_oidc_provider_url" {
  description = "A URL do provedor OIDC do cluster (ex: oidc.eks.REGION.amazonaws.com/id/CLUSTER_ID)."
  type        = string
}

variable "crossplane_namespace" {
  description = "O namespace do Kubernetes onde o Crossplane está instalado."
  type        = string
  default     = "crossplane-system"
}

variable "crossplane_service_account" {
  description = "O nome do Service Account do Kubernetes usado pelo Crossplane."
  type        = string
  default     = "provider-aws-controller"
}

variable "policy_arn" {
  description = "O ARN da política IAM que define as permissões do Crossplane. Recomenda-se criar uma política customizada com o princípio do menor privilégio."
  type        = string
  default     = null
}

variable "tags" {
  description = "Um mapa de tags para adicionar à role."
  type        = map(string)
  default     = {}
}