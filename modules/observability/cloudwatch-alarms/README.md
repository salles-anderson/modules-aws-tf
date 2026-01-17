# CloudWatch Alarms

Módulo Terraform para criação e gerenciamento de CloudWatch Alarms com suporte a alarmes customizados, alarmes compostos e presets pré-configurados para ECS, RDS, Lambda e ALB.

## Recursos Criados

- `aws_sns_topic` - Tópico SNS opcional para notificações
- `aws_sns_topic_subscription` - Assinaturas do tópico SNS
- `aws_cloudwatch_metric_alarm` - Alarmes de métricas customizados e presets
- `aws_cloudwatch_composite_alarm` - Alarmes compostos

## Presets Disponíveis

### ECS Service Alarms
- **CPU**: Alarme quando utilização de CPU ultrapassa threshold (padrão: 80%)
- **Memória**: Alarme quando utilização de memória ultrapassa threshold (padrão: 80%)

### RDS Alarms
- **CPU**: Alarme quando utilização de CPU ultrapassa threshold (padrão: 80%)
- **Memória**: Alarme quando memória livre fica abaixo do threshold (padrão: 256MB)
- **Storage**: Alarme quando espaço livre fica abaixo do threshold (padrão: 5GB)
- **Conexões**: Alarme quando número de conexões ultrapassa threshold (padrão: 100)

### Lambda Alarms
- **Erros**: Alarme quando ocorrem erros (padrão: > 0)
- **Duração**: Alarme quando duração média ultrapassa threshold (padrão: 5000ms)
- **Throttling**: Alarme quando ocorrem throttles (padrão: > 0)

### ALB Alarms
- **5XX**: Alarme quando erros 5XX ultrapassam threshold (padrão: 10)
- **Unhealthy Hosts**: Alarme quando há hosts não saudáveis (padrão: > 0)
- **Latência**: Alarme quando latência ultrapassa threshold (padrão: 1s)

## Uso

### Básico com Presets

```hcl
module "alarms" {
  source = "../../modules/observability/cloudwatch-alarms"

  project_name     = "minha-aplicacao"
  create_sns_topic = true

  sns_subscriptions = {
    email = {
      protocol = "email"
      endpoint = "alerts@example.com"
    }
  }

  # Alarmes ECS
  ecs_service_alarms = {
    api = {
      cluster_name   = "meu-cluster"
      service_name   = "api-service"
      cpu_threshold  = 75
    }
    worker = {
      cluster_name      = "meu-cluster"
      service_name      = "worker-service"
      memory_threshold  = 90
    }
  }

  # Alarmes RDS
  rds_alarms = {
    database = {
      db_instance_identifier = "meu-db"
      cpu_threshold          = 85
      connections_threshold  = 200
    }
  }

  tags = {
    Environment = "production"
  }
}
```

### Alarmes Customizados

```hcl
module "alarms" {
  source = "../../modules/observability/cloudwatch-alarms"

  project_name   = "minha-aplicacao"
  sns_topic_arns = ["arn:aws:sns:us-east-1:123456789012:existing-topic"]

  metric_alarms = {
    custom-metric-alarm = {
      description         = "Alarme customizado para métrica específica"
      comparison_operator = "GreaterThanThreshold"
      evaluation_periods  = 2
      metric_name         = "CustomMetric"
      namespace           = "Custom/Namespace"
      period              = 60
      statistic           = "Average"
      threshold           = 100
      dimensions = {
        Environment = "production"
      }
    }
  }
}
```

### Alarmes Compostos

```hcl
module "alarms" {
  source = "../../modules/observability/cloudwatch-alarms"

  project_name     = "minha-aplicacao"
  create_sns_topic = true

  ecs_service_alarms = {
    api = {
      cluster_name = "meu-cluster"
      service_name = "api-service"
    }
  }

  composite_alarms = {
    api-critical = {
      description = "Alarme crítico quando CPU e Memória estão altos"
      alarm_rule  = "ALARM(api-ecs-cpu-high) AND ALARM(api-ecs-memory-high)"
    }
  }
}
```

### Com Metric Queries (Expressões)

```hcl
module "alarms" {
  source = "../../modules/observability/cloudwatch-alarms"

  project_name     = "minha-aplicacao"
  create_sns_topic = true

  metric_alarms = {
    error-rate = {
      description         = "Taxa de erros acima de 5%"
      comparison_operator = "GreaterThanThreshold"
      evaluation_periods  = 3
      threshold           = 5

      metric_queries = [
        {
          id          = "e1"
          expression  = "m2/m1*100"
          label       = "Error Rate"
          return_data = true
        },
        {
          id = "m1"
          metric = {
            metric_name = "RequestCount"
            namespace   = "AWS/ApplicationELB"
            period      = 300
            stat        = "Sum"
            dimensions = {
              LoadBalancer = "app/my-alb/1234567890"
            }
          }
        },
        {
          id = "m2"
          metric = {
            metric_name = "HTTPCode_Target_5XX_Count"
            namespace   = "AWS/ApplicationELB"
            period      = 300
            stat        = "Sum"
            dimensions = {
              LoadBalancer = "app/my-alb/1234567890"
            }
          }
        }
      ]
    }
  }
}
```

## Variáveis

| Nome | Descrição | Tipo | Padrão | Obrigatório |
|------|-----------|------|--------|-------------|
| project_name | Nome do projeto para tagueamento | string | - | Sim |
| create_sns_topic | Criar tópico SNS para notificações | bool | false | Não |
| sns_topic_name | Nome do tópico SNS | string | null | Não |
| sns_kms_key_id | ARN da chave KMS para o tópico SNS | string | null | Não |
| sns_topic_arns | ARNs de tópicos SNS existentes | list(string) | [] | Não |
| sns_subscriptions | Assinaturas do tópico SNS | map(object) | {} | Não |
| metric_alarms | Alarmes de métricas customizados | any | {} | Não |
| composite_alarms | Alarmes compostos | map(object) | {} | Não |
| ecs_service_alarms | Alarmes pré-configurados para ECS | map(object) | {} | Não |
| rds_alarms | Alarmes pré-configurados para RDS | map(object) | {} | Não |
| lambda_alarms | Alarmes pré-configurados para Lambda | map(object) | {} | Não |
| alb_alarms | Alarmes pré-configurados para ALB | map(object) | {} | Não |
| tags | Tags adicionais | map(string) | {} | Não |

## Outputs

| Nome | Descrição |
|------|-----------|
| sns_topic_arn | ARN do tópico SNS criado |
| sns_topic_name | Nome do tópico SNS criado |
| metric_alarm_arns | Mapa de ARNs dos alarmes customizados |
| metric_alarm_names | Mapa de nomes dos alarmes customizados |
| composite_alarm_arns | Mapa de ARNs dos alarmes compostos |
| ecs_cpu_alarm_arns | Mapa de ARNs dos alarmes de CPU do ECS |
| ecs_memory_alarm_arns | Mapa de ARNs dos alarmes de memória do ECS |
| rds_cpu_alarm_arns | Mapa de ARNs dos alarmes de CPU do RDS |
| rds_memory_alarm_arns | Mapa de ARNs dos alarmes de memória do RDS |
| rds_storage_alarm_arns | Mapa de ARNs dos alarmes de storage do RDS |
| rds_connections_alarm_arns | Mapa de ARNs dos alarmes de conexões do RDS |
| lambda_errors_alarm_arns | Mapa de ARNs dos alarmes de erros do Lambda |
| lambda_duration_alarm_arns | Mapa de ARNs dos alarmes de duração do Lambda |
| lambda_throttles_alarm_arns | Mapa de ARNs dos alarmes de throttling do Lambda |
| alb_5xx_alarm_arns | Mapa de ARNs dos alarmes de 5XX do ALB |
| alb_unhealthy_alarm_arns | Mapa de ARNs dos alarmes de hosts não saudáveis do ALB |
| alb_latency_alarm_arns | Mapa de ARNs dos alarmes de latência do ALB |
| all_alarm_arns | Lista de todos os ARNs de alarmes |
