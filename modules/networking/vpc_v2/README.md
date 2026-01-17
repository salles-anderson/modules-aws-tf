# VPC v2 Module

Este modulo replica o comportamento do modulo legado `networking/vpc`, sem alterar o legado.
A unica diferenca funcional e o controle granular de VPC Endpoints via `vpc_endpoints`.

## Comportamento

- Mesmo padrao de VPC/subnets/IGW/RT/NAT/flow logs do legado.
- Interface igual ao legado, com a variavel nova `vpc_endpoints`.
- `vpc_endpoints = {}` nao cria nenhum endpoint.
- Para cada item com `enabled = true`, o endpoint e criado.
- `enable_vpc_endpoints` permanece por compatibilidade, mas o controle e feito por `vpc_endpoints`.

## vpc_endpoints

Tipo:

```
map(object({
  enabled             = optional(bool, true)
  type                = optional(string, "Interface") # Gateway | Interface
  service             = string
  service_name        = optional(string)
  private_dns_enabled = optional(bool, true)
  route_table_ids     = optional(list(string))
  subnet_ids          = optional(list(string))
  security_group_ids  = optional(list(string))
  tags                = optional(map(string), {})
}))
```

Regras:

- `service_name`: se omitido, usa `com.amazonaws.<region>.<service>`.
- Gateway endpoints: `route_table_ids` usa o valor informado; se omitido, usa as route tables do modulo.
- Interface endpoints: `subnet_ids` usa o valor informado; se omitido, usa subnets privadas do modulo.
- Interface endpoints: `security_group_ids` usa o valor informado; se omitido, usa `var.vpc_endpoint_security_group_ids`.

## Exemplo rapido

Sem endpoints:

```hcl
module "vpc" {
  source = "../.."

  project_name = "vpc-v2-no-endpoints"
  vpc_cidr     = "10.10.0.0/16"
  azs          = ["us-east-1a", "us-east-1b"]

  public_subnets  = ["10.10.1.0/24", "10.10.2.0/24"]
  private_subnets = ["10.10.101.0/24", "10.10.102.0/24"]

  enable_nat_gateway = true
}
```

Com endpoints:

```hcl
module "vpc" {
  source = "../.."

  project_name = "vpc-v2-with-endpoints"
  vpc_cidr     = "10.20.0.0/16"
  azs          = ["us-east-1a", "us-east-1b"]

  public_subnets  = ["10.20.1.0/24", "10.20.2.0/24"]
  private_subnets = ["10.20.101.0/24", "10.20.102.0/24"]

  enable_nat_gateway = true

  vpc_endpoint_security_group_ids = ["sg-0123456789abcdef0"]

  vpc_endpoints = {
    s3 = {
      type    = "Gateway"
      service = "s3"
    }

    ecr_api = {
      type    = "Interface"
      service = "ecr.api"
    }

    ssm = {
      type    = "Interface"
      service = "ssm"
    }
  }
}
```
