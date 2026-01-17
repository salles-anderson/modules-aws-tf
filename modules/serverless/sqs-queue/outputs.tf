output "queue_id" {
  description = "ID da fila SQS."
  value       = aws_sqs_queue.this.id
}

output "queue_arn" {
  description = "ARN da fila SQS."
  value       = aws_sqs_queue.this.arn
}

output "queue_url" {
  description = "URL da fila SQS."
  value       = aws_sqs_queue.this.url
}

output "dlq_arn" {
  description = "ARN da DLQ criada, se habilitada."
  value       = try(aws_sqs_queue.dlq[0].arn, null)
}
