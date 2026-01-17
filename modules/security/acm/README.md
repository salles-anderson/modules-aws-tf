# ACM Certificate Module

Este módulo solicita e valida automaticamente um certificado SSL/TLS público usando o AWS Certificate Manager (ACM) e validação via DNS no Route53.

## Arquitetura

O módulo cria:
*   `aws_acm_certificate`: O certificado em si.
*   `aws_route53_record`: Registros DNS CNAME necessários para a validação do certificado.
*   `aws_acm_certificate_validation`: Recurso que aguarda a propagação do DNS e a emissão do certificado.

## Requisitos

*   Uma Hosted Zone no Route53 gerenciada pela mesma conta AWS.

## Uso Básico

```hcl
module "cert" {
  source = "../../modules/security/acm"

  domain_name    = "example.com"
  hosted_zone_id = "Z1234567890ABCDEF"
}
```

## Uso com SANs (Subject Alternative Names)

```hcl
module "cert_san" {
  source = "../../modules/security/acm"

  domain_name               = "example.com"
  subject_alternative_names = ["www.example.com", "api.example.com"]
  hosted_zone_id            = "Z1234567890ABCDEF"
}
```

## Exemplos

Consulte `examples/acm/` para exemplos detalhados.
*   [Basic](examples/acm/basic): Certificado para um domínio único.
*   [Wildcard](examples/acm/wildcard): Certificado wildcard.

## Entradas (Inputs)

| Nome | Descrição | Tipo | Padrão | Obrigatório |
|------|-----------|------|--------|:-----------:|
| `domain_name` | Domínio principal. | `string` | n/a | Sim |
| `subject_alternative_names` | Lista de SANs. | `list(string)` | `[]` | Não |
| `hosted_zone_id` | ID da Hosted Zone. | `string` | n/a | Sim |
| `tags` | Tags adicionais. | `map(string)` | `{}` | Não |

## Saídas (Outputs)

| Nome | Descrição |
|------|-----------|
| `arn` | ARN do certificado. |
| `id` | ID do certificado. |
| `status` | Status do certificado. |
| `validation_fqdns` | FQDNs dos registros de validação. |
