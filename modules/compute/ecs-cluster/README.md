# ECS Cluster Module

Cria um cluster ECS com Container Insights opcional e associação de capacity providers (FARGATE/FARGATE_SPOT).

## Uso Básico

```hcl
module "ecs_cluster" {
  source = "../../modules/compute/ecs-cluster"

  project_name = "plataforma-assinatura"
  cluster_name = "core-ecs"
}
```

## Inputs

| Nome | Descrição | Tipo | Padrão | Obrigatório |
|------|-----------|------|--------|:-----------:|
| `project_name` | Nome do projeto usado para taguear recursos. | `string` | n/a | Sim |
| `cluster_name` | Nome do cluster ECS. | `string` | n/a | Sim |
| `enable_container_insights` | Habilita o Container Insights no cluster. | `bool` | `true` | Não |
| `capacity_providers` | Lista de capacity providers (ex.: `FARGATE`, `FARGATE_SPOT`). | `list(string)` | `[]` | Não |
| `default_capacity_provider_strategy` | Estratégia padrão quando `capacity_providers` é usado. | `list(object({ capacity_provider = string, weight = number, base = number }))` | `[]` | Não |
| `tags` | Mapa de tags adicionais. | `map(string)` | `{}` | Não |

## Outputs

| Nome | Descrição |
|------|-----------|
| `cluster_id` | ID do cluster ECS. |
| `cluster_arn` | ARN do cluster ECS. |
| `cluster_name` | Nome do cluster ECS. |
