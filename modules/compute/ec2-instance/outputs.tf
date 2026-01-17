output "id" {
  description = "O ID da instância EC2."
  value       = aws_instance.this.id
}

output "arn" {
  description = "O ARN da instância."
  value       = aws_instance.this.arn
}

output "private_ip" {
  description = "O endereço de IP privado da instância."
  value       = aws_instance.this.private_ip
}

output "public_ip" {
  description = "O endereço de IP público da instância, se aplicável."
  value       = aws_instance.this.public_ip
}

output "public_dns" {
  description = "O nome DNS público da instância, se aplicável."
  value       = aws_instance.this.public_dns
}