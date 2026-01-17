variable "project_name" {
  description = "The name of the project."
  type        = string
}

variable "table_name" {
  description = "The name of the DynamoDB table."
  type        = string
}

variable "billing_mode" {
  description = "The billing mode for the table (PROVISIONED or PAY_PER_REQUEST)."
  type        = string
  default     = "PAY_PER_REQUEST"
}

variable "hash_key" {
  description = "The attribute to use as the hash key."
  type        = string
}

variable "range_key" {
  description = "The attribute to use as the range key."
  type        = string
  default     = null
}

variable "attributes" {
  description = "A list of attributes for the table."
  type = list(object({
    name = string
    type = string
  }))
  default = []
}

variable "tags" {
  description = "A map of tags to assign to the table."
  type        = map(string)
  default     = {}
}