# IAM Crossplane Role Module

Este módulo cria uma IAM Role para ser utilizada pelo [Crossplane](https://crossplane.io/) em clusters Kubernetes, utilizando IAM Roles for Service Accounts (IRSA).

## Arquitetura

O módulo cria:
*   `aws_iam_role`: Role com política de confiança (Trust Policy) configurada para permitir que o Service Account do Crossplane assuma a role via OIDC.
*   `aws_iam_role_policy_attachment` (opcional): Anexa uma política gerenciada ou customizada à role.

## Uso Básico

```hcl
module "crossplane_role" {
  source = "../../modules/iam/crossplane-role"

  project_name               = "my-cluster"
  cluster_oidc_provider_arn  = "arn:aws:iam::123456789012:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/EXAMPLE123456789012"
  cluster_oidc_provider_url  = "oidc.eks.us-east-1.amazonaws.com/id/EXAMPLE123456789012"
  policy_arn                 = "arn:aws:iam::aws:policy/AdministratorAccess" # Cuidado: Use menor privilégio em produção
}
```

## Exemplos

Consulte `examples/crossplane-role/` para exemplos detalhados.
*   [Basic](examples/crossplane-role/basic): Exemplo básico com IRSA.

## Entradas (Inputs)

| Nome | Descrição | Tipo | Padrão | Obrigatório |
|------|-----------|------|--------|:-----------:|
| `project_name` | Nome do projeto. | `string` | n/a | Sim |
| `cluster_oidc_provider_arn` | ARN do provedor OIDC do cluster. | `string` | n/a | Sim |
| `cluster_oidc_provider_url` | URL do provedor OIDC do cluster. | `string` | n/a | Sim |
| `crossplane_namespace` | Namespace do Crossplane. | `string` | `crossplane-system` | Não |
| `crossplane_service_account` | Service Account do Crossplane. | `string` | `provider-aws-controller` | Não |
| `policy_arn` | ARN da política de permissões. | `string` | `null` | Não |
| `tags` | Tags adicionais. | `map(string)` | `{}` | Não |

## Saídas (Outputs)

| Nome | Descrição |
|------|-----------|
| `iam_role_arn` | ARN da role criada. |
