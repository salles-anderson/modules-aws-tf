# Cognito User Pool Module

Cria um User Pool do Cognito com App Client configurável, política de senha e MFA opcional.

## Uso Básico

```hcl
module "cognito" {
  source = "../../modules/security/cognito-user-pool"

  project_name          = "plataforma-assinatura"
  user_pool_name        = "usuarios"
  user_pool_client_name = "web-client"
}
```

## Inputs

| Nome | Descrição | Tipo | Padrão | Obrigatório |
|------|-----------|------|--------|:-----------:|
| `project_name` | Nome do projeto para taguear recursos. | `string` | n/a | Sim |
| `user_pool_name` | Nome do User Pool. | `string` | n/a | Sim |
| `user_pool_client_name` | Nome do App Client. | `string` | n/a | Sim |
| `auto_verified_attributes` | Atributos auto-verificados. | `list(string)` | `["email"]` | Não |
| `mfa_configuration` | Configuração de MFA (`OFF`, `ON`, `OPTIONAL`). | `string` | `"OFF"` | Não |
| `email_verification_subject` | Assunto do e-mail de verificação. | `string` | `"Verifique seu e-mail"` | Não |
| `email_verification_message` | Mensagem do e-mail de verificação. | `string` | `"Seu código de verificação é {####}."` | Não |
| `password_min_length` | Comprimento mínimo da senha. | `number` | `8` | Não |
| `password_require_lowercase` | Requer minúsculas. | `bool` | `true` | Não |
| `password_require_numbers` | Requer números. | `bool` | `true` | Não |
| `password_require_symbols` | Requer símbolos. | `bool` | `true` | Não |
| `password_require_uppercase` | Requer maiúsculas. | `bool` | `true` | Não |
| `temporary_password_validity_days` | Validade da senha temporária (dias). | `number` | `7` | Não |
| `client_generate_secret` | Gera secret para o App Client. | `bool` | `true` | Não |
| `client_callback_urls` | Callback URLs do App Client. | `list(string)` | `[]` | Não |
| `client_logout_urls` | Logout URLs do App Client. | `list(string)` | `[]` | Não |
| `client_allowed_oauth_flows` | Fluxos OAuth permitidos. | `list(string)` | `[]` | Não |
| `client_allowed_oauth_scopes` | Escopos OAuth permitidos. | `list(string)` | `[]` | Não |
| `client_supported_identity_providers` | IdPs suportados. | `list(string)` | `[]` | Não |
| `client_explicit_auth_flows` | Fluxos explícitos permitidos. | `list(string)` | `["ALLOW_USER_SRP_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]` | Não |
| `tags` | Mapa de tags adicionais. | `map(string)` | `{}` | Não |

## Outputs

| Nome | Descrição |
|------|-----------|
| `user_pool_id` | ID do User Pool. |
| `user_pool_arn` | ARN do User Pool. |
| `user_pool_client_id` | ID do App Client. |
