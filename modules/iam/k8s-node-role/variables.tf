variable "project_name" {
  description = "Nome do projeto para taguear os recursos e dar nome à role."
  type        = string
}

variable "tags" {
  description = "Um mapa de tags para adicionar aos recursos criados."
  type        = map(string)
  default     = {}
}