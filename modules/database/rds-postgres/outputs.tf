output "db_instance_arn" {
  description = "O ARN da instância de banco de dados."
  value       = aws_db_instance.this.arn
}

output "db_instance_id" {
  description = "O identificador da instância de banco de dados."
  value       = aws_db_instance.this.id
}

output "db_instance_address" {
  description = "O endereço (endpoint) da instância de banco de dados."
  value       = aws_db_instance.this.address
}

output "db_instance_port" {
  description = "A porta de conexão da instância de banco de dados."
  value       = aws_db_instance.this.port
}

output "db_instance_username" {
  description = "O nome de usuário mestre da instância de banco de dados."
  value       = aws_db_instance.this.username
}

output "db_subnet_group_name" {
  description = "O nome do grupo de sub-redes do banco de dados."
  value       = aws_db_subnet_group.this.name
}