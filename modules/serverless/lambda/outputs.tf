output "lambda_function_arn" {
  description = "ARN da função Lambda criada."
  value       = aws_lambda_function.this.arn
}

output "lambda_function_name" {
  description = "Nome da função Lambda."
  value       = aws_lambda_function.this.function_name
}

output "lambda_role_arn" {
  description = "ARN da IAM Role utilizada pela Lambda."
  value       = aws_iam_role.lambda.arn
}

output "lambda_security_group_ids" {
  description = "Security groups associados à função."
  value       = local.lambda_in_vpc ? coalesce(length(var.lambda_security_group_ids) > 0 ? var.lambda_security_group_ids : null, aws_security_group.lambda[*].id) : []
}
