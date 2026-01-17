# KMS Key Module

Cria uma chave KMS gerenciada pelo cliente com alias opcional e rotação habilitada.

## Uso Básico

```hcl
module "kms" {
  source = "../../modules/security/kms-key"

  project_name = "plataforma-assinatura"
  alias_name   = "app-secrets"
}
```

## Inputs

| Nome | Descrição | Tipo | Padrão | Obrigatório |
|------|-----------|------|--------|:-----------:|
| `project_name` | Nome do projeto para taguear recursos. | `string` | n/a | Sim |
| `description` | Descrição da chave. | `string` | `"Chave gerenciada pelo cliente"` | Não |
| `deletion_window_in_days` | Janela de deleção (dias). | `number` | `30` | Não |
| `enable_key_rotation` | Habilita rotação anual automática. | `bool` | `true` | Não |
| `is_enabled` | Habilita a chave. | `bool` | `true` | Não |
| `multi_region` | Define a chave como multi-região. | `bool` | `false` | Não |
| `policy` | Política IAM em JSON. | `string` | `null` | Não |
| `alias_name` | Nome do alias (sem prefixo `alias/`). | `string` | `null` | Não |
| `tags` | Mapa de tags adicionais. | `map(string)` | `{}` | Não |

## Outputs

| Nome | Descrição |
|------|-----------|
| `key_id` | ID da chave. |
| `key_arn` | ARN da chave. |
| `alias` | Alias criado, se definido. |
