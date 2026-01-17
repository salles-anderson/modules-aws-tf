# Application Load Balancer (ALB) Module

Este módulo provisiona um Application Load Balancer (ALB) na AWS, juntamente com seus Target Groups e Listeners.

## Arquitetura

O módulo cria:
*   `aws_lb`: O balanceador de carga.
*   `aws_lb_target_group`: Grupos de destino dinâmicos.
*   `aws_lb_listener`: Listeners que roteiam tráfego para os grupos de destino.

## Características

*   Suporte para criação dinâmica de múltiplos Target Groups e Listeners via mapas.
*   Configuração flexível de Health Checks para cada Target Group.
*   Suporte a SSL/TLS (HTTPS) nos listeners.
*   Suporte a Access Logs (S3).

## Uso Básico

```hcl
module "alb" {
  source = "../../modules/networking/alb"

  project_name       = "my-project"
  name               = "my-alb"
  internal           = false
  vpc_id             = "vpc-12345"
  subnet_ids         = ["subnet-1", "subnet-2"]
  security_group_ids = ["sg-1"]

  target_groups = {
    app = {
      port        = 80
      protocol    = "HTTP"
      target_type = "ip"
      health_check_path = "/health"
    }
  }

  listeners = {
    http = {
      port             = 80
      protocol         = "HTTP"
      action_type      = "forward"
      target_group_key = "app"
    }
  }
}
```

## Exemplos

Consulte `examples/alb/` para exemplos detalhados:
*   [HTTP](examples/alb/http): Exemplo de ALB HTTP simples.
*   [HTTPS](examples/alb/https): Exemplo de ALB com terminação HTTPS (Requer certificado ACM).

## Entradas (Inputs)

| Nome | Descrição | Tipo | Padrão | Obrigatório |
|------|-----------|------|--------|:-----------:|
| `project_name` | Nome do projeto. | `string` | n/a | Sim |
| `name` | Nome base do ALB. | `string` | n/a | Sim |
| `internal` | Se `true`, cria ALB interno. | `bool` | `false` | Não |
| `vpc_id` | ID da VPC. | `string` | n/a | Sim |
| `subnet_ids` | Lista de IDs de Subnets. | `list(string)` | n/a | Sim |
| `security_group_ids` | Lista de IDs de Security Groups. | `list(string)` | n/a | Sim |
| `target_groups` | Mapa de configuração de Target Groups. | `any` | `{}` | Não |
| `listeners` | Mapa de configuração de Listeners. | `any` | `{}` | Não |
| `access_logs` | Configuração de logs de acesso (Bucket S3). | `object` | `disabled` | Não |
| `tags` | Tags adicionais. | `map(string)` | `{}` | Não |

## Saídas (Outputs)

| Nome | Descrição |
|------|-----------|
| `lb_arn` | ARN do Load Balancer. |
| `lb_dns_name` | DNS Name do Load Balancer. |
| `lb_zone_id` | Zone ID do Load Balancer (para Route53). |
| `target_group_arns` | Mapa de ARNs dos Target Groups. |
| `listener_arns` | Mapa de ARNs dos Listeners. |
