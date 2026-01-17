# Route53 Module

Este módulo gerencia registros DNS em uma Hosted Zone existente no Amazon Route 53.

## Arquitetura

O módulo cria um ou mais recursos `aws_route53_record` baseados na configuração fornecida.

## Características

*   Suporte a registros simples (A, CNAME, TXT, etc.) com TTL e valores.
*   Suporte a registros ALIAS (para apontar para ALBs, CloudFront, S3, etc.).
*   Validação de entrada para garantir que os campos obrigatórios estejam presentes.

## Uso Básico

```hcl
module "dns_records" {
  source = "../../modules/networking/route53"

  zone_id = "Z1234567890ABCDEF"

  records = {
    www = {
      name   = "www"
      type   = "A"
      ttl    = 300
      values = ["192.0.2.1"]
    }
    api = {
      name   = "api"
      type   = "CNAME"
      ttl    = 60
      values = ["api.example.com"]
    }
  }
}
```

## Uso com Alias

```hcl
module "dns_alias" {
  source = "../../modules/networking/route53"

  zone_id = "Z1234567890ABCDEF"

  records = {
    app = {
      name = "app"
      type = "A"
      alias = {
        name                   = "my-alb-12345.us-east-1.elb.amazonaws.com"
        zone_id                = "Z35SXDOTRQ7X7K" # Hosted Zone do ALB
        evaluate_target_health = true
      }
    }
  }
}
```

## Exemplos

Consulte `examples/route53/` para exemplos detalhados:
*   [Simple](examples/route53/simple): Registros padrão (A, CNAME).
*   [Alias](examples/route53/alias): Registro ALIAS apontando para um ALB.

## Entradas (Inputs)

| Nome | Descrição | Tipo | Padrão | Obrigatório |
|------|-----------|------|--------|:-----------:|
| `zone_id` | ID da Hosted Zone. | `string` | n/a | Sim |
| `records` | Mapa de configuração dos registros. | `any` | `{}` | Não |

## Saídas (Outputs)

| Nome | Descrição |
|------|-----------|
| `record_fqdns` | Mapa dos FQDNs criados. |
