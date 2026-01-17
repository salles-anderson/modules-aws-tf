# CloudWatch Dashboards

Módulo Terraform para criação e gerenciamento de CloudWatch Dashboards com suporte a dashboards customizados e templates pré-construídos para ECS, RDS, Lambda e ALB.

## Recursos Criados

- `aws_cloudwatch_dashboard` - Dashboards customizados e pré-construídos

## Templates Disponíveis

### ECS Dashboard
- CPU Utilization
- Memory Utilization
- Running/Desired/Pending Task Count
- Network RX/TX Bytes

### RDS Dashboard
- CPU Utilization
- Freeable Memory
- Free Storage Space
- Database Connections
- Read/Write IOPS
- Read/Write Latency
- Network Throughput
- Read/Write Throughput

### Lambda Dashboard
- Invocations
- Errors
- Throttles
- Duration (Average e p99)
- Concurrent Executions
- Error Rate

### ALB Dashboard
- Request Count
- Active/New Connection Count
- HTTP Status Codes (ELB e Target)
- Target Response Time
- Healthy/Unhealthy Host Count
- Processed Bytes
- Rejected Connection Count

### Overview Dashboard
Dashboard consolidado com métricas resumidas de todos os serviços configurados.

## Uso

### Dashboard ECS

```hcl
module "dashboards" {
  source = "../../modules/observability/cloudwatch-dashboards"

  project_name = "minha-aplicacao"
  aws_region   = "us-east-1"

  ecs_dashboards = {
    "minha-app-ecs" = {
      cluster_name  = "meu-cluster"
      service_names = ["api-service", "worker-service"]
    }
  }
}
```

### Dashboard RDS

```hcl
module "dashboards" {
  source = "../../modules/observability/cloudwatch-dashboards"

  project_name = "minha-aplicacao"
  aws_region   = "us-east-1"

  rds_dashboards = {
    "minha-app-rds" = {
      db_instance_identifier = "meu-db"
    }
  }
}
```

### Dashboard Lambda

```hcl
module "dashboards" {
  source = "../../modules/observability/cloudwatch-dashboards"

  project_name = "minha-aplicacao"
  aws_region   = "us-east-1"

  lambda_dashboards = {
    "minha-app-lambda" = {
      function_names = ["func-1", "func-2", "func-3"]
    }
  }
}
```

### Dashboard ALB

```hcl
module "dashboards" {
  source = "../../modules/observability/cloudwatch-dashboards"

  project_name = "minha-aplicacao"
  aws_region   = "us-east-1"

  alb_dashboards = {
    "minha-app-alb" = {
      load_balancer_arn_suffix = "app/my-alb/1234567890"
      target_group_arn_suffix  = "targetgroup/my-tg/1234567890"
    }
  }
}
```

### Dashboard de Visão Geral

```hcl
module "dashboards" {
  source = "../../modules/observability/cloudwatch-dashboards"

  project_name = "minha-aplicacao"
  aws_region   = "us-east-1"

  create_overview_dashboard = true

  overview_ecs_clusters = [
    {
      cluster_name = "meu-cluster"
      service_name = "api-service"
    },
    {
      cluster_name = "meu-cluster"
      service_name = "worker-service"
    }
  ]

  overview_rds_instances = ["meu-db-1", "meu-db-2"]

  overview_lambda_functions = ["func-1", "func-2"]

  overview_alb_arns = ["app/my-alb/1234567890"]
}
```

### Dashboard Customizado

```hcl
module "dashboards" {
  source = "../../modules/observability/cloudwatch-dashboards"

  project_name = "minha-aplicacao"
  aws_region   = "us-east-1"

  dashboards = {
    "meu-dashboard-custom" = {
      body = jsonencode({
        widgets = [
          {
            type   = "metric"
            x      = 0
            y      = 0
            width  = 12
            height = 6
            properties = {
              title   = "Minha Métrica Custom"
              region  = "us-east-1"
              metrics = [
                ["Custom/Namespace", "MetricName", "Dimension", "Value"]
              ]
              view    = "timeSeries"
              stacked = false
              period  = 300
              stat    = "Average"
            }
          }
        ]
      })
    }
  }
}
```

## Variáveis

| Nome | Descrição | Tipo | Padrão | Obrigatório |
|------|-----------|------|--------|-------------|
| project_name | Nome do projeto para tagueamento | string | - | Sim |
| aws_region | Região AWS para os widgets | string | - | Sim |
| dashboards | Dashboards customizados | map(object) | {} | Não |
| ecs_dashboards | Dashboards ECS pré-construídos | map(object) | {} | Não |
| rds_dashboards | Dashboards RDS pré-construídos | map(object) | {} | Não |
| lambda_dashboards | Dashboards Lambda pré-construídos | map(object) | {} | Não |
| alb_dashboards | Dashboards ALB pré-construídos | map(object) | {} | Não |
| create_overview_dashboard | Criar dashboard de visão geral | bool | false | Não |
| overview_dashboard_name | Nome do dashboard de visão geral | string | null | Não |
| overview_ecs_clusters | Clusters ECS para o overview | list(object) | [] | Não |
| overview_rds_instances | Instâncias RDS para o overview | list(string) | [] | Não |
| overview_lambda_functions | Funções Lambda para o overview | list(string) | [] | Não |
| overview_alb_arns | ARNs de ALB para o overview | list(string) | [] | Não |
| tags | Tags adicionais | map(string) | {} | Não |

## Outputs

| Nome | Descrição |
|------|-----------|
| custom_dashboard_arns | Mapa de ARNs dos dashboards customizados |
| ecs_dashboard_arns | Mapa de ARNs dos dashboards ECS |
| rds_dashboard_arns | Mapa de ARNs dos dashboards RDS |
| lambda_dashboard_arns | Mapa de ARNs dos dashboards Lambda |
| alb_dashboard_arns | Mapa de ARNs dos dashboards ALB |
| overview_dashboard_arn | ARN do dashboard de visão geral |
| all_dashboard_names | Lista de nomes de todos os dashboards |
