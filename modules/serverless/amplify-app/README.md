# Amplify App Module

Cria uma aplicação AWS Amplify com opção de conexão a repositório Git via token. Sem token, a conexão pode ser feita manualmente no Console.

## Uso Básico (conexão manual via Console)

```hcl
module "amplify" {
  source    = "../../modules/serverless/amplify-app"

  project_name = "plataforma-assinatura"
  app_name     = "frontend"
}
```

## Uso com repositório

```hcl
module "amplify" {
  source    = "../../modules/serverless/amplify-app"

  project_name = "plataforma-assinatura"
  app_name     = "frontend"
  repository   = "https://github.com/org/frontend"
  oauth_token  = var.github_token
}
```

## Inputs

| Nome | Descrição | Tipo | Padrão | Obrigatório |
|------|-----------|------|--------|:-----------:|
| `project_name` | Nome do projeto para taguear recursos. | `string` | n/a | Sim |
| `app_name` | Nome da aplicação Amplify. | `string` | n/a | Sim |
| `repository` | URL do repositório Git (usado quando `oauth_token` for informado). | `string` | `null` | Não |
| `oauth_token` | Token OAuth/PAT para o repositório. | `string` | `null` | Não |
| `iam_service_role_arn` | IAM Role usada pelo Amplify. | `string` | `null` | Não |
| `platform` | Plataforma alvo (ex.: `WEB`). | `string` | `"WEB"` | Não |
| `enable_auto_branch_creation` | Cria apps automaticamente para novos branches. | `bool` | `false` | Não |
| `auto_branch_creation_patterns` | Padrões de branches para auto criação. | `list(string)` | `["*"]` | Não |
| `build_spec` | Buildspec custom em YAML. | `string` | `null` | Não |
| `basic_auth_credentials` | Credenciais de basic auth (`user:pass`). | `string` | `null` | Não |
| `custom_rules` | Regras de redirect. | `list(object)` | `[]` | Não |
| `environment_variables` | Variáveis de ambiente do app. | `map(string)` | `{}` | Não |
| `tags` | Mapa de tags adicionais. | `map(string)` | `{}` | Não |

## Outputs

| Nome | Descrição |
|------|-----------|
| `app_id` | ID da aplicação. |
| `app_arn` | ARN da aplicação. |
| `default_domain` | Domínio padrão gerado pelo Amplify. |
