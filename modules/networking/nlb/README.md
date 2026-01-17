# Network Load Balancer (NLB) Module

Módulo para provisionar um Network Load Balancer (NLB) com IPs elásticos (EIP) opcionais para cada AZ, listeners e target groups preparados para uso com ECS Fargate (target_type `ip`).

## Arquitetura
- `aws_lb` com `subnet_mapping` (permite associar EIP fixo por AZ).
- `aws_lb_target_group` (suporte a protocolos TCP/TLS/UDP e health check configurável).
- `aws_lb_listener` apontando para os target groups.

## Uso Básico (NLB com EIP fixo para Fargate)

```hcl
module "eip_a" {
  source      = "../../modules/networking/eip"
  project_name = "my-project"
  name         = "nlb-a"
}

module "eip_b" {
  source      = "../../modules/networking/eip"
  project_name = "my-project"
  name         = "nlb-b"
}

module "nlb" {
  source = "../../modules/networking/nlb"

  project_name = "my-project"
  name         = "svc-nlb"
  vpc_id       = "vpc-123"

  subnet_mappings = [
    { subnet_id = "subnet-az-a", allocation_id = module.eip_a.allocation_id },
    { subnet_id = "subnet-az-b", allocation_id = module.eip_b.allocation_id },
  ]

  target_groups = {
    app = {
      port        = 80
      protocol    = "TCP"
      target_type = "ip" # obrigatório para Fargate
    }
  }

  listeners = {
    tcp_80 = {
      port             = 80
      protocol         = "TCP"
      target_group_key = "app"
    }
  }
}
```

## Entradas (Inputs)

| Nome | Descrição | Tipo | Padrão | Obrigatório |
|------|-----------|------|--------|:-----------:|
| `project_name` | Nome do projeto para tags. | `string` | n/a | Sim |
| `name` | Nome base do NLB. | `string` | n/a | Sim |
| `internal` | NLB interno (`true`) ou internet-facing (`false`). | `bool` | `false` | Não |
| `vpc_id` | VPC onde o NLB/TGs serão criados. | `string` | n/a | Sim |
| `subnet_mappings` | Lista de subnets com EIP opcional (`subnet_id`, `allocation_id`). Um por AZ. | `list(object)` | n/a | Sim |
| `target_groups` | Mapa de TGs (porta, protocolo e `target_type` — usar `ip` para Fargate). Health check configurável. | `map(object)` | `{}` | Não |
| `listeners` | Mapa de listeners apontando para TGs (`port`, `protocol`, `target_group_key`, TLS opcional). | `map(object)` | `{}` | Não |
| `enable_cross_zone_load_balancing` | Ativa cross-zone. | `bool` | `true` | Não |
| `enable_deletion_protection` | Protege contra deleção. | `bool` | `false` | Não |
| `tags` | Tags adicionais. | `map(string)` | `{}` | Não |

## Saídas (Outputs)

| Nome | Descrição |
|------|-----------|
| `lb_arn` | ARN do NLB. |
| `lb_dns_name` | DNS público do NLB. |
| `lb_zone_id` | Hosted Zone ID (para alias Route53). |
| `target_group_arns` | Mapa de ARNs dos Target Groups. |
| `listener_arns` | Mapa de ARNs dos Listeners. |
| `subnet_mapping_eips` | Mapa `subnet_id` -> `allocation_id` associado. |
