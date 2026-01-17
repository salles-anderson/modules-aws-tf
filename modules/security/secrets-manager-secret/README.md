# Secrets Manager Secret Module

Cria um secret no AWS Secrets Manager com criptografia via KMS opcional e versão inicial configurável.

## Uso Básico

```hcl
module "secret" {
  source = "../../modules/security/secrets-manager-secret"

  project_name = "plataforma-assinatura"
  name         = "db-credentials"
  secret_string = jsonencode({
    username = "app",
    password = "super-senha"
  })
}
```

## Inputs

| Nome | Descrição | Tipo | Padrão | Obrigatório |
|------|-----------|------|--------|:-----------:|
| `project_name` | Nome do projeto para taguear recursos. | `string` | n/a | Sim |
| `name` | Nome do secret. | `string` | n/a | Sim |
| `description` | Descrição do secret. | `string` | `null` | Não |
| `kms_key_id` | KMS Key para criptografia. | `string` | `null` | Não |
| `recovery_window_in_days` | Janela de recuperação antes da deleção permanente. | `number` | `30` | Não |
| `force_overwrite_replica_secret` | Força overwrite em segredos replicados. | `bool` | `false` | Não |
| `secret_string` | Valor inicial do secret. | `string` | `null` | Não |
| `tags` | Mapa de tags adicionais. | `map(string)` | `{}` | Não |

## Outputs

| Nome | Descrição |
|------|-----------|
| `secret_id` | ID do secret. |
| `secret_arn` | ARN do secret. |
| `secret_version_id` | ID da versão criada (quando `secret_string` informado). |
