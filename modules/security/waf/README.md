# WAF Web ACL Module

Cria um Web ACL do AWS WAFv2 (REGIONAL ou CLOUDFRONT) com opções de regras gerenciadas, rate limit, logging e associação opcional para ALB. Todas as novas features são opt-in para evitar breaking changes.

## Notas importantes
- `scope="CLOUDFRONT"` **deve** ser criado na região `us-east-1`; o módulo valida a região e falha com mensagem clara se diferente. Configure um provider alias `aws.us_east_1` no root module e passe via `providers`.
- `association_resource_arns` só é usada em `scope="REGIONAL"` (ex.: ALB). Para CloudFront/Amplify, use `web_acl_id`/`web_acl_arn` diretamente no recurso.
- Prioridades de regras devem ser únicas; ao habilitar `enable_aws_managed_common_rules` ou `enable_rate_limit`, ajuste `aws_managed_common_priority` e `rate_priority` para não colidir com `managed_rule_groups`.

## Uso rápido

### ALB (REGIONAL)
```hcl
provider "aws" {
  region = "sa-east-1"
}

module "waf_alb" {
  source = "../../modules/security/waf-web-acl"

  project_name = "plataforma-assinatura"
  name         = "waf-alb"
  scope        = "REGIONAL"

  managed_rule_groups = [
    {
      name        = "AWSManagedRulesCommonRuleSet"
      vendor_name = "AWS"
      priority    = 1
    }
  ]

  association_resource_arns = [
    aws_lb.app.arn,
  ]
}
```

### CloudFront/Amplify (CLOUDFRONT em us-east-1)
```hcl
provider "aws" {
  region = "sa-east-1"
}

provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

module "waf_cf" {
  source    = "../../modules/security/waf-web-acl"
  providers = { aws = aws.us_east_1 }

  project_name = "plataforma-assinatura"
  name         = "waf-cf"
  scope        = "CLOUDFRONT"

  managed_rule_groups = [
    {
      name        = "AWSManagedRulesCommonRuleSet"
      vendor_name = "AWS"
      priority    = 1
    }
  ]
}

resource "aws_cloudfront_distribution" "this" {
  # demais blocos...
  web_acl_id = module.waf_cf.web_acl_arn
}
```

## Inputs

| Nome | Descrição | Tipo | Padrão | Obrigatório |
|------|-----------|------|--------|:-----------:|
| `project_name` | Nome do projeto para taguear recursos. | `string` | n/a | Sim |
| `name` | Nome do Web ACL. | `string` | n/a | Sim |
| `scope` | Escopo (`REGIONAL` ou `CLOUDFRONT`). | `string` | n/a | Sim |
| `description` | Descrição do Web ACL. | `string` | `null` | Não |
| `default_action` | Ação padrão (`allow` ou `block`). | `string` | `"allow"` | Não |
| `managed_rule_groups` | Lista de managed rule groups. | `list(object)` | `[]` | Não |
| `association_resource_arns` | ARNs de recursos regionais para associar (ex.: ALB). Só para `scope=REGIONAL`. | `list(string)` | `[]` | Não |
| `enable_logging` | Habilita logging do Web ACL. | `bool` | `false` | Não |
| `logging_destination_arn` | ARN do Firehose de destino. Obrigatório se `enable_logging=true`. | `string` | `null` | Não |
| `redacted_fields` | Campos para suprimir no logging (`method`, `query_string`, `uri_path`, `body`, `all_query_arguments`, `single_header`, `single_query_argument`). | `list(object)` | `[]` | Não |
| `enable_rate_limit` | Habilita regra rate-based. | `bool` | `false` | Não |
| `rate_limit` | Limite de requisições da regra rate-based. | `number` | `2000` | Não |
| `rate_aggregate_key_type` | Chave de agregação (`IP` ou `FORWARDED_IP`). | `string` | `"IP"` | Não |
| `rate_forwarded_ip_config` | Configuração para `FORWARDED_IP` (header_name, fallback_behavior). | `object` | `null` | Não |
| `rate_priority` | Prioridade da regra rate-based. | `number` | `10` | Não |
| `rate_action` | Ação da regra rate-based (`block` ou `count`). | `string` | `"block"` | Não |
| `enable_aws_managed_common_rules` | Habilita `AWSManagedRulesCommonRuleSet` automaticamente. | `bool` | `false` | Não |
| `aws_managed_common_priority` | Prioridade da regra `AWSManagedRulesCommonRuleSet`. | `number` | `1` | Não |
| `cloudwatch_metrics_enabled` | Habilita métricas do CloudWatch. | `bool` | `true` | Não |
| `sampled_requests_enabled` | Habilita sampled requests. | `bool` | `true` | Não |
| `tags` | Mapa de tags adicionais. | `map(string)` | `{}` | Não |

## Outputs

| Nome | Descrição |
|------|-----------|
| `web_acl_arn` | ARN do Web ACL. |
| `web_acl_id` | ID do Web ACL. |
| `web_acl_name` | Nome do Web ACL. |
| `web_acl_metric_name` | Nome da métrica principal do Web ACL. |

## Exemplos
- `examples/alb`: uso regional com associação a ALB.
- `examples/cloudfront`: uso CLOUDFRONT com provider alias `us-east-1` e `web_acl_id` na distribuição. Consuma estes exemplos com `terraform -chdir=examples/<dir> init/validate/plan`.
