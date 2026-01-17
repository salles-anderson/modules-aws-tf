# ECR Repository Module

Provisiona um repositório ECR com criptografia, image scanning e política de lifecycle opcional.

## Uso Básico

```hcl
module "ecr" {
  source = "../../modules/compute/ecr-repository"

  project_name    = "plataforma-assinatura"
  repository_name = "backend-api"
}
```

## Inputs

| Nome | Descrição | Tipo | Padrão | Obrigatório |
|------|-----------|------|--------|:-----------:|
| `project_name` | Nome do projeto para taguear recursos. | `string` | n/a | Sim |
| `repository_name` | Nome do repositório ECR. | `string` | n/a | Sim |
| `image_tag_mutability` | Se as tags são mutáveis (`MUTABLE`) ou imutáveis (`IMMUTABLE`). | `string` | `MUTABLE` | Não |
| `scan_on_push` | Habilita image scanning ao fazer push. | `bool` | `true` | Não |
| `encryption_type` | Tipo de criptografia (`AES256` ou `KMS`). | `string` | `AES256` | Não |
| `kms_key_arn` | ARN da chave KMS quando `encryption_type` = `KMS`. | `string` | `null` | Não |
| `lifecycle_policy` | JSON de política de lifecycle para limpeza de imagens. | `string` | `null` | Não |
| `tags` | Mapa de tags adicionais. | `map(string)` | `{}` | Não |

## Outputs

| Nome | Descrição |
|------|-----------|
| `repository_arn` | ARN do repositório ECR. |
| `repository_url` | URL do repositório ECR. |
| `repository_name` | Nome do repositório ECR. |
