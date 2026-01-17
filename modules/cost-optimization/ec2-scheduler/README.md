# EC2 Scheduler

Módulo Terraform para agendamento de stop/start de instâncias EC2, otimizando custos em ambientes de desenvolvimento e homologação.

## Recursos Criados

- `aws_lambda_function` - Função Lambda para stop/start de instâncias EC2
- `aws_iam_role` - Roles IAM para Lambda e EventBridge Scheduler
- `aws_scheduler_schedule` - Schedules para stop e start
- `aws_cloudwatch_log_group` - Log group para a Lambda

## Funcionalidades

- **Stop/Start agendado** - Para instâncias fora do horário comercial
- **Descoberta por tags** - Encontra instâncias automaticamente por tag
- **Lista explícita** - Ou especifique instâncias diretamente por ID
- **Timezone configurável** - Suporte a America/Sao_Paulo e outros
- **Logs detalhados** - Registro de todas as operações no CloudWatch

## Uso

### Básico - Lista de Instâncias

```hcl
module "ec2_scheduler" {
  source = "github.com/org/terraform-aws-modules//modules/cost-optimization/ec2-scheduler"

  project_name = "minha-app-dev"

  ec2_instance_ids = [
    "i-1234567890abcdef0",
    "i-0987654321fedcba0"
  ]

  # Horário comercial: 8h-18h seg-sex
  start_schedule = "cron(0 8 ? * MON-FRI *)"
  stop_schedule  = "cron(0 18 ? * MON-FRI *)"

  schedule_timezone = "America/Sao_Paulo"
}
```

### Descoberta por Tags (Recomendado)

```hcl
module "ec2_scheduler" {
  source = "github.com/org/terraform-aws-modules//modules/cost-optimization/ec2-scheduler"

  project_name = "dev-environment"

  # Descobre instâncias com tag Environment=dev
  resource_tag_key   = "Environment"
  resource_tag_value = "dev"

  schedule_timezone = "America/Sao_Paulo"
}
```

### Horário Estendido

```hcl
module "ec2_scheduler" {
  source = "github.com/org/terraform-aws-modules//modules/cost-optimization/ec2-scheduler"

  project_name = "dev-extended"

  resource_tag_key   = "AutoStop"
  resource_tag_value = "true"

  # 7h às 22h seg-sex
  start_schedule = "cron(0 7 ? * MON-FRI *)"
  stop_schedule  = "cron(0 22 ? * MON-FRI *)"

  schedule_timezone = "America/Sao_Paulo"
}
```

### Incluindo Fins de Semana (Dev com plantão)

```hcl
module "ec2_scheduler" {
  source = "github.com/org/terraform-aws-modules//modules/cost-optimization/ec2-scheduler"

  project_name = "staging"

  resource_tag_key   = "Environment"
  resource_tag_value = "staging"

  # Seg-Sex: 8h-20h, Sáb: 10h-16h
  # Use dois módulos separados para schedules diferentes
  start_schedule = "cron(0 8 ? * MON-FRI *)"
  stop_schedule  = "cron(0 20 ? * MON-FRI *)"

  schedule_timezone = "America/Sao_Paulo"
}
```

## Variáveis

| Nome | Descrição | Tipo | Padrão | Obrigatório |
|------|-----------|------|--------|-------------|
| project_name | Nome do projeto para tagueamento | string | - | Sim |
| ec2_instance_ids | Lista de IDs de instâncias EC2 | list(string) | [] | Não |
| resource_tag_key | Chave da tag para descoberta automática | string | null | Não |
| resource_tag_value | Valor da tag para descoberta automática | string | null | Não |
| enable_schedule | Habilita os schedules | bool | true | Não |
| schedule_timezone | Timezone dos schedules | string | America/Sao_Paulo | Não |
| stop_schedule | Cron para stop | string | cron(0 18 ? * MON-FRI *) | Não |
| start_schedule | Cron para start | string | cron(0 8 ? * MON-FRI *) | Não |
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
| log_group_name | Nome do CloudWatch Log Group |

## Economia Estimada

| Instância | Custo 24/7/mês | Com Schedule (50h/sem) | Economia |
|-----------|----------------|------------------------|----------|
| t3.micro | $9 | $3 | 67% |
| t3.small | $19 | $6 | 68% |
| t3.medium | $38 | $11 | 71% |
| t3.large | $76 | $23 | 70% |
| m5.large | $89 | $27 | 70% |
| m5.xlarge | $178 | $53 | 70% |
| r5.large | $131 | $39 | 70% |

**Nota:** O custo de EBS (storage) continua sendo cobrado mesmo com a instância parada.

## Permissões IAM Requeridas

A Lambda requer as seguintes permissões:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:DescribeInstances",
        "ec2:StartInstances",
        "ec2:StopInstances"
      ],
      "Resource": "*"
    }
  ]
}
```

## Tagging Strategy Recomendada

Para usar a descoberta automática por tags, adicione tags às suas instâncias EC2:

```hcl
resource "aws_instance" "dev" {
  # ... configuração da instância

  tags = {
    Name        = "dev-server"
    Environment = "dev"
    AutoStop    = "true"      # Para descoberta específica
    Schedule    = "business"  # Referência ao tipo de schedule
  }
}
```

## Considerações

- **Instâncias em ASG**: Instâncias gerenciadas por Auto Scaling Groups podem ser reiniciadas automaticamente. Configure o ASG para respeitar o schedule ou use scaling do ASG em vez deste módulo.
- **Spot Instances**: Instâncias Spot não podem ser paradas, apenas terminadas.
- **EBS Storage**: O armazenamento EBS continua sendo cobrado mesmo com a instância parada.
- **Elastic IPs**: IPs elásticos associados a instâncias paradas continuam sendo cobrados.
- **Estado da aplicação**: Certifique-se de que suas aplicações lidam corretamente com stop/start (graceful shutdown).

## Diferença de EC2 vs Outros Recursos

| Recurso | Limitação de Stop |
|---------|-------------------|
| **EC2** | Sem limite de tempo parado |
| **RDS** | Auto-inicia após 7 dias |
| **DocumentDB** | Auto-inicia após 7 dias |
| **Aurora** | Auto-inicia após 7 dias |

EC2 é o recurso mais simples para scheduling pois **não tem auto-start**.
