output "replication_group_id" {
  description = "ID do replication group Redis."
  value       = aws_elasticache_replication_group.this.id
}

output "primary_endpoint" {
  description = "Endpoint primário para escrita."
  value       = aws_elasticache_replication_group.this.primary_endpoint_address
}

output "reader_endpoint" {
  description = "Endpoint de leitura."
  value       = aws_elasticache_replication_group.this.reader_endpoint_address
}

output "port" {
  description = "Porta de conexão do Redis."
  value       = aws_elasticache_replication_group.this.port
}
