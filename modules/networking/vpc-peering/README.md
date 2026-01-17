# VPC Peering Module

Este módulo estabelece uma conexão de peering entre duas VPCs na mesma conta AWS e configura as rotas necessárias em ambas as direções.

## Arquitetura

O módulo cria:
*   `aws_vpc_peering_connection`: O link de rede entre as duas VPCs.
*   `aws_route`: Rotas nas tabelas de rotas fornecidas para permitir tráfego entre os CIDRs das VPCs.

## Uso Básico

```hcl
module "peering" {
  source = "../../modules/networking/vpc-peering"

  requester_vpc_id         = "vpc-A"
  requester_vpc_cidr       = "10.0.0.0/16"
  requester_route_table_id = "rtb-A"
  requester_name           = "NewVPC"

  accepter_vpc_id         = "vpc-B"
  accepter_vpc_cidr       = "172.16.0.0/16"
  accepter_route_table_id = "rtb-B"
  accepter_name           = "LegacyVPC"
}
```

## Exemplos

Consulte `examples/vpc-peering/` para exemplos detalhados.
*   [Basic](examples/vpc-peering/basic): Exemplo simples de peering entre duas VPCs.

## Entradas (Inputs)

| Nome | Descrição | Tipo | Padrão | Obrigatório |
|------|-----------|------|--------|:-----------:|
| `requester_vpc_id` | ID da VPC solicitante. | `string` | n/a | Sim |
| `requester_vpc_cidr` | CIDR da VPC solicitante. | `string` | n/a | Sim |
| `requester_route_table_id` | RT da VPC solicitante. | `string` | n/a | Sim |
| `requester_name` | Nome da VPC solicitante. | `string` | n/a | Sim |
| `accepter_vpc_id` | ID da VPC aceitante. | `string` | n/a | Sim |
| `accepter_vpc_cidr` | CIDR da VPC aceitante. | `string` | n/a | Sim |
| `accepter_route_table_id` | RT da VPC aceitante. | `string` | n/a | Sim |
| `accepter_name` | Nome da VPC aceitante. | `string` | n/a | Sim |

## Saídas (Outputs)

| Nome | Descrição |
|------|-----------|
| `peering_connection_id` | ID da conexão de peering. |
| `requester_route_id` | ID da rota no solicitante. |
| `accepter_route_id` | ID da rota no aceitante. |
| `peering_status` | Status da conexão. |
