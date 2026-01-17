# Shield Protection Module

Cria uma proteção AWS Shield para um recurso existente (ex.: ALB, NLB, CloudFront).

## Uso Básico

```hcl
module "shield" {
  source = "../../modules/security/shield-protection"

  project_name    = "plataforma-assinatura"
  protection_name = "alb-shield"
  resource_arn    = aws_lb.app.arn
}
```

## Inputs

| Nome | Descrição | Tipo | Padrão | Obrigatório |
|------|-----------|------|--------|:-----------:|
| `project_name` | Nome do projeto (mantido por consistência de interface). | `string` | n/a | Sim |
| `protection_name` | Nome amigável da proteção. | `string` | n/a | Sim |
| `resource_arn` | ARN do recurso protegido. | `string` | n/a | Sim |
| `health_check_arns` | ARNs de health checks associados. | `list(string)` | `[]` | Não |
| `tags` | Mapa de tags adicionais (não suportado pelo recurso). | `map(string)` | `{}` | Não |

## Outputs

| Nome | Descrição |
|------|-----------|
| `protection_id` | ID da proteção (ARN do recurso). |
