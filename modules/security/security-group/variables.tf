variable "project_name" {
  description = "Nome do projeto para taguear os recursos de forma consistente."
  type        = string
}

variable "name" {
  description = "Nome do Security Group."
  type        = string
}

variable "description" {
  description = "Descrição do Security Group."
  type        = string
  default     = "Managed by Terraform"
}

variable "vpc_id" {
  description = "ID da VPC onde o Security Group será criado."
  type        = string
}

variable "ingress_rules" {
  description = "List of ingress rules"
  type = list(object({
    from_port                = number
    to_port                  = number
    protocol                 = string
    cidr_blocks              = optional(list(string), [])
    source_security_group_id = optional(string, null)
    description              = optional(string, "Managed by Terraform")
  }))
  default = []

  validation {
    condition = alltrue([
      for rule in var.ingress_rules :
      contains(["tcp", "udp", "icmp", "-1"], rule.protocol)
    ])
    error_message = "Protocol must be one of: tcp, udp, icmp, or -1 (all)."
  }

  validation {
    condition = alltrue([
      for rule in var.ingress_rules :
      rule.from_port >= 0 && rule.from_port <= 65535
    ])
    error_message = "from_port must be between 0 and 65535."
  }

  validation {
    condition = alltrue([
      for rule in var.ingress_rules :
      rule.to_port >= 0 && rule.to_port <= 65535
    ])
    error_message = "to_port must be between 0 and 65535."
  }
}

variable "egress_rules" {
  description = "List of egress rules"
  type = list(object({
    from_port                     = number
    to_port                       = number
    protocol                      = string
    cidr_blocks                   = optional(list(string), [])
    destination_security_group_id = optional(string, null)
    description                   = optional(string, "Managed by Terraform")
  }))
  default = [{
    from_port                     = 0
    to_port                       = 0
    protocol                      = "-1"
    cidr_blocks                   = ["0.0.0.0/0"]
    description                   = "Allow all outbound traffic"
    destination_security_group_id = null
  }]

  validation {
    condition = alltrue([
      for rule in var.egress_rules :
      contains(["tcp", "udp", "icmp", "-1"], rule.protocol)
    ])
    error_message = "Protocol must be one of: tcp, udp, icmp, or -1 (all)."
  }

  validation {
    condition = alltrue([
      for rule in var.egress_rules :
      rule.from_port >= 0 && rule.from_port <= 65535
    ])
    error_message = "from_port must be between 0 and 65535."
  }

  validation {
    condition = alltrue([
      for rule in var.egress_rules :
      rule.to_port >= 0 && rule.to_port <= 65535
    ])
    error_message = "to_port must be between 0 and 65535."
  }
}

variable "tags" {
  description = "Um mapa de tags customizadas para adicionar ao Security Group."
  type        = map(string)
  default     = {}
}
