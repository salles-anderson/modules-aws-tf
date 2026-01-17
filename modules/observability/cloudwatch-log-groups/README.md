# CloudWatch Log Groups

Módulo Terraform para criação e gerenciamento de CloudWatch Log Groups com suporte a filtros de assinatura e filtros de métricas.

## Recursos Criados

- `aws_cloudwatch_log_group` - Log groups com suporte a KMS e retenção configurável
- `aws_cloudwatch_log_subscription_filter` - Filtros de assinatura para streaming de logs
- `aws_cloudwatch_log_metric_filter` - Filtros para extração de métricas dos logs

## Uso

```hcl
module "log_groups" {
  source = "../../modules/observability/cloudwatch-log-groups"

  project_name = "minha-aplicacao"

  log_groups = {
    app = {
      name              = "/ecs/minha-app"
      retention_in_days = 30
    }
    api = {
      name              = "/ecs/minha-api"
      retention_in_days = 90
      kms_key_id        = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
    }
  }

  subscription_filters = {
    app-to-kinesis = {
      log_group_key   = "app"
      destination_arn = "arn:aws:kinesis:us-east-1:123456789012:stream/my-stream"
      filter_pattern  = "[ERROR]"
    }
  }

  metric_filters = {
    error-count = {
      log_group_key    = "app"
      pattern          = "ERROR"
      metric_name      = "ErrorCount"
      metric_namespace = "MinhaApp/Logs"
    }
  }

  tags = {
    Environment = "production"
  }
}
```

## Variáveis

| Nome | Descrição | Tipo | Padrão | Obrigatório |
|------|-----------|------|--------|-------------|
| project_name | Nome do projeto para tagueamento | string | - | Sim |
| log_groups | Mapa de log groups a serem criados | map(object) | {} | Não |
| default_retention_in_days | Período de retenção padrão em dias | number | 30 | Não |
| subscription_filters | Mapa de filtros de assinatura | map(object) | {} | Não |
| metric_filters | Mapa de filtros de métricas | map(object) | {} | Não |
| tags | Tags adicionais | map(string) | {} | Não |

### Estrutura de log_groups

```hcl
log_groups = {
  key = {
    name              = string           # Nome do log group (obrigatório)
    retention_in_days = number           # Dias de retenção (opcional)
    kms_key_id        = string           # ARN da chave KMS (opcional)
    log_group_class   = string           # STANDARD ou INFREQUENT_ACCESS (opcional)
    skip_destroy      = bool             # Preservar na destruição (opcional)
    tags              = map(string)      # Tags específicas (opcional)
  }
}
```

### Estrutura de subscription_filters

```hcl
subscription_filters = {
  key = {
    log_group_key   = string  # Chave do log group no mapa log_groups (obrigatório)
    destination_arn = string  # ARN do destino (Kinesis, Lambda, etc) (obrigatório)
    filter_pattern  = string  # Padrão de filtro (opcional, padrão: "")
    role_arn        = string  # ARN da role IAM (opcional)
    distribution    = string  # Random ou ByLogStream (opcional)
  }
}
```

### Estrutura de metric_filters

```hcl
metric_filters = {
  key = {
    log_group_key    = string       # Chave do log group (obrigatório)
    pattern          = string       # Padrão de filtro (obrigatório)
    metric_name      = string       # Nome da métrica (obrigatório)
    metric_namespace = string       # Namespace da métrica (obrigatório)
    metric_value     = string       # Valor da métrica (opcional, padrão: "1")
    default_value    = number       # Valor padrão quando não há match (opcional)
    unit             = string       # Unidade da métrica (opcional)
    dimensions       = map(string)  # Dimensões adicionais (opcional)
  }
}
```

## Outputs

| Nome | Descrição |
|------|-----------|
| log_group_arns | Mapa de ARNs dos log groups criados |
| log_group_names | Mapa de nomes dos log groups criados |
| subscription_filter_names | Lista de nomes dos filtros de assinatura |
| metric_filter_names | Lista de nomes dos filtros de métricas |
