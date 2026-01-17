output "table_arn" {
  description = "The ARN of the DynamoDB table."
  value       = aws_dynamodb_table.this.arn
}

output "table_id" {
  description = "The ID of the DynamoDB table."
  value       = aws_dynamodb_table.this.id
}