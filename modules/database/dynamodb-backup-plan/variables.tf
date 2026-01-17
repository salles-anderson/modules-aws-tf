variable "project_name" {
  description = "The name of the project."
  type        = string
}

variable "vault_name" {
  description = "The name of the AWS Backup vault."
  type        = string
}

variable "plan_name" {
  description = "The name of the AWS Backup plan."
  type        = string
}

variable "selection_name" {
  description = "The name for the backup selection."
  type        = string
}

variable "iam_role_arn" {
  description = "The ARN of the IAM role for AWS Backup."
  type        = string
}

variable "table_arns" {
  description = "A list of DynamoDB table ARNs to back up."
  type        = list(string)
}

variable "tags" {
  description = "A map of tags to assign to the resources."
  type        = map(string)
  default     = {}
}