output "public_ip" {
  description = "O endereço de IP público alocado."
  value       = aws_eip.this.public_ip
}

output "allocation_id" {
  description = "O ID de alocação do EIP, usado para associá-lo."
  value       = aws_eip.this.id
}

output "private_ip" {
  description = "O IP privado da instância à qual o EIP está associado."
  value       = var.instance_id != null ? aws_eip.this.private_ip : null
}

output "association_id" {
  description = "O ID da associação do EIP."
  value       = join("", aws_eip_association.this.*.id)
}