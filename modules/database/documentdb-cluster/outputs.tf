output "cluster_id" {
  description = "ID do cluster DocumentDB."
  value       = aws_docdb_cluster.this.id
}

output "cluster_arn" {
  description = "ARN do cluster DocumentDB."
  value       = aws_docdb_cluster.this.arn
}

output "endpoint" {
  description = "Endpoint principal do cluster."
  value       = aws_docdb_cluster.this.endpoint
}

output "reader_endpoint" {
  description = "Endpoint de leitura do cluster."
  value       = aws_docdb_cluster.this.reader_endpoint
}

output "instance_endpoints" {
  description = "Endpoints das instâncias."
  value       = aws_docdb_cluster_instance.this[*].endpoint
}
