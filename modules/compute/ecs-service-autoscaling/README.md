# ECS Service Auto Scaling Module

Configura o AWS Application Auto Scaling para ajustar o `desired_count` de um serviço ECS usando Target Tracking baseado em CPU e memória, sem criar alarmes manuais do CloudWatch.

## Características
* Usa métricas pré-definidas do ECS (`ECSServiceAverageCPUUtilization` e `ECSServiceAverageMemoryUtilization`).
* Somente Target Tracking Scaling (sem Step Scaling); os alarmes são criados e gerenciados automaticamente pela AWS.
* Controla `desired_count` com limites mínimos/máximos, cooldowns configuráveis e opção de `disable_scale_in` para evitar flapping.
* Suporta scale-to-zero com `min_capacity = 0` quando o serviço puder ser desligado totalmente.
* Pode usar RequestCountPerTarget do ALB para escalar serviços HTTP/HTTPS atrás de um load balancer.
* Compatível com módulos de ECS Service (mantenha `desired_count` ignorado em lifecycle no serviço para evitar drift).

## Uso Básico

```hcl
module "ecs_service_autoscaling" {
  source = "../../modules/compute/ecs-service-autoscaling"

  project_name = "my-app"
  cluster_name = "app-cluster"
  service_name = "web"
  min_capacity = 1
  max_capacity = 5
}
```

### Escalando por ALB (RequestCountPerTarget)

```hcl
data "aws_lb" "app" {
  name = "app-alb"
}

data "aws_lb_target_group" "app" {
  name = "app-tg"
}

module "ecs_service_autoscaling" {
  source = "../../modules/compute/ecs-service-autoscaling"

  project_name = "my-app"
  cluster_name = "app-cluster"
  service_name = "web"
  min_capacity = 1
  max_capacity = 10

  enable_alb_scaling             = true
  alb_load_balancer_arn_suffix   = data.aws_lb.app.arn_suffix        # app/<name>/<id>
  alb_target_group_arn_suffix    = data.aws_lb_target_group.app.arn_suffix # targetgroup/<name>/<id>
  alb_request_count_target_value = 120
}
```

`alb_request_count_target_value` é expresso em requests por target; comece com um valor seguro (ex.: `100`) e ajuste conforme latência/erro aceitável da aplicação.

## Exemplos

Consulte `examples/ecs-service-autoscaling` para usos completos:
* `basic`: habilita CPU e memória com os defaults seguros.
* `cpu-and-memory`: ajusta valores-alvo e cooldowns para ambientes mais sensíveis a flapping.

## Notas de Estabilidade

* `scale_in_cooldown` e `scale_out_cooldown` ajudam a suavizar picos; aumente-os em workloads com variação brusca.
* `disable_scale_in = true` impede reduções automáticas quando o serviço precisa manter capacidade estável.
* `min_capacity = 0` habilita scale-to-zero; avalie cold start e dependências antes de usar.
* Os alarmes do CloudWatch são criados automaticamente pelo Application Auto Scaling; não é necessário (nem suportado aqui) criar `aws_cloudwatch_metric_alarm`.

## Inputs

| Nome | Descrição | Tipo | Padrão | Obrigatório |
|------|-----------|------|--------|:-----------:|
| `project_name` | Nome do projeto usado para padronizar nomes. | `string` | n/a | Sim |
| `cluster_name` | Nome do cluster ECS (não ARN). | `string` | n/a | Sim |
| `service_name` | Nome do serviço ECS cujo `desired_count` será escalado. | `string` | n/a | Sim |
| `min_capacity` | Limite inferior do `desired_count` (pode ser `0` para scale-to-zero). | `number` | n/a | Sim |
| `max_capacity` | Limite superior do `desired_count` (>= `min_capacity`). | `number` | n/a | Sim |
| `enable_cpu_scaling` | Cria policy de Target Tracking baseada em CPU. | `bool` | `true` | Não |
| `cpu_target_value` | Utilização média de CPU desejada. | `number` | `60` | Não |
| `enable_memory_scaling` | Cria policy de Target Tracking baseada em memória. | `bool` | `true` | Não |
| `memory_target_value` | Utilização média de memória desejada. | `number` | `70` | Não |
| `enable_alb_scaling` | Cria policy de Target Tracking baseada em RequestCountPerTarget do ALB. | `bool` | `false` | Não |
| `alb_load_balancer_arn_suffix` | ARN suffix do ALB no formato `app/<name>/<id>` (necessário quando `enable_alb_scaling = true`). | `string` | `null` | Não |
| `alb_target_group_arn_suffix` | ARN suffix do Target Group no formato `targetgroup/<name>/<id>` (necessário quando `enable_alb_scaling = true`). | `string` | `null` | Não |
| `alb_request_count_target_value` | Requests por target desejados (`ALBRequestCountPerTarget`). | `number` | `100` | Não |
| `scale_in_cooldown` | Cooldown (s) antes de novo scale-in. | `number` | `120` | Não |
| `scale_out_cooldown` | Cooldown (s) antes de novo scale-out. | `number` | `60` | Não |
| `disable_scale_in` | Impede ações de scale-in nos policies. | `bool` | `false` | Não |
| `tags` | Mapa de tags adicionais (mantido para padrão; App Auto Scaling não aplica tags diretamente). | `map(string)` | `{}` | Não |

## Outputs

| Nome | Descrição |
|------|-----------|
| `autoscaling_target_arn` | Identificador do scalable target retornado pelo App Auto Scaling. |
| `resource_id` | Resource ID `service/<cluster>/<service>` usado pelas policies. |
| `cpu_policy_arn` | ARN da policy de Target Tracking por CPU (ou `null`). |
| `memory_policy_arn` | ARN da policy de Target Tracking por memória (ou `null`). |
