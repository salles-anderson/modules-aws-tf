output "peering_connection_id" {
  description = "O ID exclusivo da conexão de VPC Peering (pcx-...). Útil para referências externas ou documentação."
  value       = aws_vpc_peering_connection.main.id
}

output "requester_route_id" {
  description = "O ID da rota criada na VPC Solicitante (Nova VPC) para o peering."
  value       = aws_route.requester_to_accepter.id
}

output "accepter_route_id" {
  description = "O ID da rota criada na VPC Aceitante (VPC Padrão Antiga) para o peering."
  value       = aws_route.accepter_to_requester.id
}

output "peering_status" {
  description = "Status da conexão de VPC Peering"
  value       = aws_vpc_peering_connection.main.accept_status
}