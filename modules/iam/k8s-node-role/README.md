# Kubernetes Node IAM Role Module

Este módulo cria uma IAM Role e um Instance Profile configurados com as permissões necessárias para nós de um cluster Kubernetes (como o RKE2) rodando em EC2.

## Arquitetura

O módulo cria:
*   `aws_iam_role`: Role com política de confiança para o serviço EC2.
*   Anexos de políticas gerenciadas:
    *   `AmazonEC2ContainerRegistryReadOnly`: Para puxar imagens do ECR.
    *   `AmazonSSMManagedInstanceCore`: Para gerenciamento via Systems Manager (SSM).
    *   `CloudWatchAgentServerPolicy`: Para envio de métricas e logs ao CloudWatch.
*   `aws_iam_instance_profile`: Perfil de instância para associar a role às instâncias EC2.

## Uso Básico

```hcl
module "k8s_node_role" {
  source = "../../modules/iam/k8s-node-role"

  project_name = "my-k8s-cluster"
}
```

## Exemplos

Consulte `examples/k8s-node-role/` para exemplos detalhados.
*   [Basic](examples/k8s-node-role/basic): Exemplo padrão.

## Entradas (Inputs)

| Nome | Descrição | Tipo | Padrão | Obrigatório |
|------|-----------|------|--------|:-----------:|
| `project_name` | Nome do projeto. | `string` | n/a | Sim |
| `tags` | Tags adicionais. | `map(string)` | `{}` | Não |

## Saídas (Outputs)

| Nome | Descrição |
|------|-----------|
| `iam_role_arn` | ARN da IAM Role criada. |
| `instance_profile_name` | Nome do Instance Profile criado. |
