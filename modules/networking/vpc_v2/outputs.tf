# Touched to include in patch
output "vpc_id" {
  description = "O ID da VPC (criada ou existente)."
  value       = local.vpc_id
}

output "vpc_cidr_block" {
  description = "O bloco CIDR da VPC."
  value       = local.vpc_cidr_block
}

output "public_subnet_ids" {
  description = "Lista de IDs das sub-redes públicas (criadas ou encontradas)."
  value       = var.create_vpc ? aws_subnet.public[*].id : one(data.aws_subnets.public_existing[*].ids)
}

output "private_subnet_ids" {
  description = "Lista de IDs das sub-redes privadas (criadas ou encontradas)."
  value       = var.create_vpc ? aws_subnet.private[*].id : one(data.aws_subnets.private_existing[*].ids)
}

output "nat_gateway_public_ip" {
  description = "O IP público do NAT Gateway, se criado."
  value       = one(aws_eip.nat[*].public_ip)
}

output "vpc_endpoint_s3_id" {
  description = "ID of the S3 VPC Endpoint"
  value       = try(aws_vpc_endpoint.this["s3"].id, null)
}

output "vpc_endpoint_ecr_api_id" {
  description = "ID of the ECR API VPC Endpoint"
  value       = try(aws_vpc_endpoint.this["ecr_api"].id, null)
}

output "vpc_endpoint_ecr_dkr_id" {
  description = "ID of the ECR DKR VPC Endpoint"
  value       = try(aws_vpc_endpoint.this["ecr_dkr"].id, null)
}

output "vpc_endpoint_ssm_id" {
  description = "ID of the SSM VPC Endpoint"
  value       = try(aws_vpc_endpoint.this["ssm"].id, null)
}
