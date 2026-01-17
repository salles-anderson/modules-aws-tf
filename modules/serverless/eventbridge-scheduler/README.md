# EventBridge Scheduler Module

Módulo reutilizável para criar cronogramas do EventBridge Scheduler responsáveis por invocar uma função Lambda específica. Inclui criação da IAM Role necessária, policy mínima e permissão na própria Lambda.

## Inputs principais

| Variável                                                   | Descrição                                                 |
| ---------------------------------------------------------- | --------------------------------------------------------- |
| `project_name`                                             | Nome do projeto usado nas tags.                           |
| `lambda_function_arn`                                      | ARN da função a ser invocada.                             |
| `lambda_function_name`                                     | Nome da função (necessário para `aws_lambda_permission`). |
| `schedule_name` / `schedule_expression`                    | Identificação e frequência do cronograma.                 |
| `target_input`                                             | Payload enviado à Lambda (string JSON).                   |
| `schedule_retry_attempts`, `schedule_event_age_in_seconds` | Configurações opcionais de retentativas.                  |

## Exemplo

```hcl
module "lambda" {
  source = "../teck-modulos/lambda"
  # ... parâmetros ...
}

module "eventbridge-scheduler" {
  source = "git@github.com:TeckSolucoes/terraform-aws-modules.git//modules/serverless/eventbridge-scheduler?refref=v1.0.0"

  project_name          = "frontconsig"
  schedule_name         = "frontconsig-lambda-eventbridge-homolog"
  schedule_expression   = "rate(3 minutes)"
  lambda_function_arn   = module.lambda.lambda_function_arn
  lambda_function_name  = module.lambda.lambda_function_name
  target_input          = jsonencode({ source = "scheduler" })
}
```

Outputs disponibilizados:

- `scheduler_arn`
- `scheduler_role_arn`
