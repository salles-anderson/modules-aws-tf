# Amazon ECR Module

Este módulo provisiona um repositório Amazon Elastic Container Registry (ECR) com criptografia, escaneamento de imagens, políticas opcionais e regras de ciclo de vida.

## Arquitetura

O módulo cria:
*   `aws_ecr_repository`: Repositório ECR com criptografia e scan on push configuráveis.
*   `aws_ecr_lifecycle_policy`: Opcional, define regras para expirar versões antigas de imagens.
*   `aws_ecr_repository_policy`: Opcional, anexa uma política customizada para compartilhamento cross-account ou restrições adicionais.

## Características

*   **Segurança:** Criptografia KMS opcional, tags imutáveis e escaneamento automático de vulnerabilidades.
*   **Governança:** Suporte a políticas customizadas para controlar quem pode ler/gravar no repositório.
*   **Custos:** Regras de lifecycle facilitam limpeza de imagens antigas para reduzir armazenamento.

## Uso Básico

```hcl
module "ecr" {
  source = "../../modules/storage/ecr"

  name                 = "my-app"
  image_tag_mutability = "IMMUTABLE"
  scan_on_push         = true

  lifecycle_rules = [
    {
      priority    = 1
      description = "Manter apenas 10 tags com prefixo release-"
      selection = {
        tag_status   = "tagged"
        tag_prefixes = ["release-"]
        count_type   = "imageCountMoreThan"
        count_number = 10
      }
      action = {
        type = "expire"
      }
    }
  ]

  tags = {
    Environment = "dev"
    Project     = "awesome-app"
  }
}
```

## Entradas (Inputs)

| Nome | Descrição | Tipo | Padrão | Obrigatório |
|------|-----------|------|--------|:-----------:|
| `name` | Nome do repositório ECR. | `string` | n/a | Sim |
| `image_tag_mutability` | Define se tags são mutáveis (`MUTABLE`) ou imutáveis (`IMMUTABLE`). | `string` | `"IMMUTABLE"` | Não |
| `scan_on_push` | Habilita escaneamento de vulnerabilidades em pushes. | `bool` | `true` | Não |
| `encryption_type` | Tipo de criptografia (`AES256` ou `KMS`). | `string` | `"AES256"` | Não |
| `kms_key_arn` | ARN da chave KMS quando `encryption_type = "KMS"`. | `string` | `null` | Não |
| `force_delete` | Permite deletar repositório mesmo com imagens. | `bool` | `false` | Não |
| `lifecycle_rules` | Lista de regras de lifecycle para expirar imagens. | `list(object)` | `[]` | Não |
| `repository_policy_json` | Política JSON opcional anexada ao repositório. | `string` | `null` | Não |
| `tags` | Tags adicionais aplicadas ao recurso. | `map(string)` | `{}` | Não |

> Observação: Para usar `encryption_type = "KMS"`, forneça uma chave válida em `kms_key_arn`.

## Saídas (Outputs)

| Nome | Descrição |
|------|-----------|
| `repository_arn` | ARN do repositório ECR. |
| `repository_name` | Nome do repositório. |
| `repository_url` | URL utilizada para push/pull (`<aws_account_id>.dkr.ecr.<region>.amazonaws.com/<repo>`). |
| `registry_id` | ID do registro associado. |
