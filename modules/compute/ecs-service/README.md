# ECS Service Module

Este módulo gerencia um serviço ECS e sua definição de tarefa associada.

## Arquitetura

O módulo cria:
*   `aws_ecs_task_definition`: Define como os contêineres devem ser executados (imagem, CPU, memória, portas).
*   `aws_ecs_service`: Garante que o número especificado de tarefas esteja em execução e as conecta a um Load Balancer (opcional).

## Características

*   Suporte principal para **Fargate**, mas configurável para EC2.
*   Configuração de rede `awsvpc`.
*   Suporte a integração com Load Balancers (ALB/NLB).
*   `lifecycle` configurado para ignorar mudanças manuais em `desired_count` (Auto Scaling) e `task_definition` (Deploys via CI/CD).

## Uso Básico (Fargate)

```hcl
module "my_service" {
  source = "../../modules/compute/ecs-service"

  project_name            = "my-app"
  name                    = "frontend"
  cluster_id              = "arn:aws:ecs:us-east-1:123456789012:cluster/my-cluster"
  task_execution_role_arn = "arn:aws:iam::123456789012:role/ecsTaskExecutionRole"

  task_cpu    = 256
  task_memory = 512
  subnet_ids  = ["subnet-1", "subnet-2"]
  security_group_ids = ["sg-1"]

  container_definitions = jsonencode([
    {
      name  = "app"
      image = "nginx:latest"
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
}
```

## Exemplos

Consulte `examples/ecs-service/` para exemplos detalhados:
*   [Fargate](examples/ecs-service/fargate): Exemplo padrão usando Fargate.

## Entradas (Inputs)

| Nome | Descrição | Tipo | Padrão | Obrigatório |
|------|-----------|------|--------|:-----------:|
| `project_name` | Nome do projeto. | `string` | n/a | Sim |
| `name` | Nome do serviço e família da task. | `string` | n/a | Sim |
| `cluster_id` | ID do Cluster ECS. | `string` | n/a | Sim |
| `container_definitions` | Definição dos containers em JSON string. | `string` | n/a | Sim |
| `task_execution_role_arn` | ARN da role de execução da task. | `string` | n/a | Sim |
| `task_role_arn` | ARN da role da task. | `string` | `null` | Não |
| `task_cpu` | CPU da task (obrigatório para Fargate). | `number` | `null` | Não |
| `task_memory` | Memória da task (obrigatório para Fargate). | `number` | `null` | Não |
| `subnet_ids` | IDs das Subnets. | `list(string)` | `[]` | Sim (awsvpc) |
| `security_group_ids` | IDs dos Security Groups. | `list(string)` | `[]` | Sim (awsvpc) |
| `desired_count` | Número de tasks desejadas. | `number` | `1` | Não |
| `load_balancers` | Lista de configurações de LB. | `any` | `[]` | Não |
| `enable_execute_command` | Habilita ECS Exec. | `bool` | `true` | Não |
| `assign_public_ip` | Atribui IP público. | `bool` | `false` | Não |
| `tags` | Tags adicionais. | `map(string)` | `{}` | Não |

## Saídas (Outputs)

| Nome | Descrição |
|------|-----------|
| `service_name` | Nome do serviço criado. |
| `task_definition_arn` | ARN da Task Definition. |
| `task_definition_family` | Família da Task Definition. |
