output "cluster_id" {
  description = "Identificador do cluster Aurora."
  value       = aws_rds_cluster.this.id
}

output "cluster_arn" {
  description = "ARN do cluster Aurora."
  value       = aws_rds_cluster.this.arn
}

output "writer_endpoint" {
  description = "Endpoint writer do cluster."
  value       = aws_rds_cluster.this.endpoint
}

output "reader_endpoint" {
  description = "Endpoint de leitura (round-robin)."
  value       = aws_rds_cluster.this.reader_endpoint
}

output "port" {
  description = "Porta de conexão do cluster."
  value       = aws_rds_cluster.this.port
}

output "subnet_group_name" {
  description = "DB subnet group usado pelo cluster."
  value       = aws_db_subnet_group.this.name
}

output "instance_ids" {
  description = "IDs das instâncias do cluster."
  value       = [for i in aws_rds_cluster_instance.this : i.id]
}

output "instance_endpoints" {
  description = "Endpoints individuais das instâncias."
  value       = [for i in aws_rds_cluster_instance.this : i.endpoint]
}

output "monitoring_role_arn" {
  description = "ARN da role usada pelo Enhanced Monitoring."
  value       = local.monitoring_role_arn
}
