# RDS Scheduler

Módulo Terraform para agendamento de stop/start de instâncias RDS, otimizando custos em ambientes de desenvolvimento e homologação.

## Recursos Criados

- `aws_lambda_function` - Função Lambda para stop/start de instâncias RDS
- `aws_iam_role` - Roles IAM para Lambda e EventBridge Scheduler
- `aws_scheduler_schedule` - Schedules para stop, start e re-stop
- `aws_cloudwatch_log_group` - Log group para a Lambda

## Funcionalidades

- **Stop/Start agendado** - Para instâncias fora do horário comercial
- **Descoberta por tags** - Encontra instâncias automaticamente por tag
- **Lista explícita** - Ou especifique instâncias diretamente
- **Re-stop automático** - Workaround para o auto-start de 7 dias da AWS
- **Timezone configurável** - Suporte a America/Sao_Paulo e outros

## Limitação Importante: Auto-Start de 7 dias

A AWS reinicia automaticamente instâncias RDS paradas por mais de 7 dias consecutivos. Este módulo oferece a opção `enable_restop_schedule` para verificar e re-parar instâncias que foram auto-iniciadas.

## Uso

### Básico - Lista de Instâncias

```hcl
module "rds_scheduler" {
  source = "github.com/org/terraform-aws-modules//modules/cost-optimization/rds-scheduler"

  project_name = "minha-app-dev"

  rds_instances = [
    "dev-postgres-1",
    "dev-mysql-1"
  ]

  # Horário comercial: 8h-18h seg-sex
  start_schedule = "cron(0 8 ? * MON-FRI *)"
  stop_schedule  = "cron(0 18 ? * MON-FRI *)"

  schedule_timezone = "America/Sao_Paulo"
}
```

### Descoberta por Tags

```hcl
module "rds_scheduler" {
  source = "github.com/org/terraform-aws-modules//modules/cost-optimization/rds-scheduler"

  project_name = "dev-environment"

  # Descobre instâncias com tag Environment=dev
  resource_tag_key   = "Environment"
  resource_tag_value = "dev"

  schedule_timezone = "America/Sao_Paulo"
}
```

### Com Re-Stop (Ambientes que ficam parados por longos períodos)

```hcl
module "rds_scheduler" {
  source = "github.com/org/terraform-aws-modules//modules/cost-optimization/rds-scheduler"

  project_name = "staging"

  resource_tag_key   = "Environment"
  resource_tag_value = "staging"

  # Habilita verificação adicional 1h após o stop
  enable_restop_schedule = true
  restop_schedule        = "cron(0 19 ? * MON-FRI *)"

  schedule_timezone = "America/Sao_Paulo"
}
```

### Horário Estendido (Dev com trabalho noturno)

```hcl
module "rds_scheduler" {
  source = "github.com/org/terraform-aws-modules//modules/cost-optimization/rds-scheduler"

  project_name = "dev-extended"

  rds_instances = ["dev-db-1"]

  # 8h às 22h seg-sex
  start_schedule = "cron(0 8 ? * MON-FRI *)"
  stop_schedule  = "cron(0 22 ? * MON-FRI *)"

  schedule_timezone = "America/Sao_Paulo"
}
```

## Variáveis

| Nome | Descrição | Tipo | Padrão | Obrigatório |
|------|-----------|------|--------|-------------|
| project_name | Nome do projeto para tagueamento | string | - | Sim |
| rds_instances | Lista de identificadores de instâncias RDS | list(string) | [] | Não |
| resource_tag_key | Chave da tag para descoberta automática | string | null | Não |
| resource_tag_value | Valor da tag para descoberta automática | string | null | Não |
| enable_schedule | Habilita os schedules | bool | true | Não |
| schedule_timezone | Timezone dos schedules | string | America/Sao_Paulo | Não |
| stop_schedule | Cron para stop | string | cron(0 18 ? * MON-FRI *) | Não |
| start_schedule | Cron para start | string | cron(0 8 ? * MON-FRI *) | Não |
| enable_restop_schedule | Habilita re-stop (workaround 7 dias) | bool | false | Não |
| restop_schedule | Cron para re-stop | string | cron(0 19 ? * MON-FRI *) | Não |
| lambda_function_name | Nome da Lambda | string | null | Não |
| lambda_timeout | Timeout da Lambda em segundos | number | 60 | Não |
| lambda_memory_size | Memória da Lambda em MB | number | 128 | Não |
| log_retention_in_days | Retenção dos logs | number | 14 | Não |
| tags | Tags adicionais | map(string) | {} | Não |

## Outputs

| Nome | Descrição |
|------|-----------|
| lambda_function_arn | ARN da função Lambda |
| lambda_function_name | Nome da função Lambda |
| lambda_role_arn | ARN da role IAM da Lambda |
| stop_schedule_arn | ARN do schedule de stop |
| start_schedule_arn | ARN do schedule de start |
| restop_schedule_arn | ARN do schedule de re-stop |
| log_group_name | Nome do CloudWatch Log Group |

## Economia Estimada

| Instância | Custo 24/7/mês | Com Schedule (50h/sem) | Economia |
|-----------|----------------|------------------------|----------|
| db.t3.micro | $15 | $4 | 73% |
| db.t3.small | $30 | $9 | 70% |
| db.t3.medium | $75 | $22 | 71% |
| db.t3.large | $150 | $45 | 70% |
| db.r5.large | $300 | $90 | 70% |

## Permissões IAM Requeridas

A Lambda requer as seguintes permissões:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "rds:DescribeDBInstances",
        "rds:StartDBInstance",
        "rds:StopDBInstance",
        "rds:ListTagsForResource"
      ],
      "Resource": "*"
    }
  ]
}
```

## Notas

- Instâncias Multi-AZ **não podem** ser paradas (limitação AWS)
- Read Replicas não são pausadas automaticamente com a primary
- O storage continua sendo cobrado mesmo com a instância parada
