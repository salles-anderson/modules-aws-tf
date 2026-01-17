# Define o recurso principal de peering
resource "aws_vpc_peering_connection" "main" {
  # O solicitante (requester)
  vpc_id = var.requester_vpc_id
  # O aceitante (accepter)
  peer_vpc_id = var.accepter_vpc_id

  # Configuração para aceitação automática (assumindo mesma conta)
  auto_accept = true

  tags = {
    Name = "pcx-${var.requester_name}-to-${var.accepter_name}"
  }
}

# ROTAS: Solicitante (Nova VPC) para Aceitante (VPC Padrão Antiga)

# Rota na VPC Solicitante
resource "aws_route" "requester_to_accepter" {
  # A Tabela de Rotas da VPC Solicitante
  route_table_id = var.requester_route_table_id
  # Destino é o CIDR da VPC Aceitante
  destination_cidr_block = var.accepter_vpc_cidr
  # Target é a Conexão de Peering
  vpc_peering_connection_id = aws_vpc_peering_connection.main.id
}

# ROTAS: Aceitante (VPC Padrão Antiga) para Solicitante (Nova VPC)

# Rota na VPC Aceitante
resource "aws_route" "accepter_to_requester" {
  route_table_id            = var.accepter_route_table_id
  destination_cidr_block    = var.requester_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.main.id
}