# S3 Bucket Module

Este módulo provisiona um bucket S3 na AWS com as melhores práticas de segurança habilitadas por padrão.

## Arquitetura

O módulo cria:
*   `aws_s3_bucket`: O bucket de armazenamento.
*   `aws_s3_bucket_public_access_block`: Bloqueia totalmente o acesso público ao bucket.
*   `aws_s3_bucket_versioning`: Habilita versionamento (configurável).
*   `aws_s3_bucket_server_side_encryption_configuration`: Habilita criptografia AES256 padrão (SSE-S3).
*   `aws_s3_bucket_policy`: Opcionalmente, adiciona uma política para negar requisições não-SSL (HTTPS only).
*   `aws_s3_bucket_lifecycle_configuration`: Opcionalmente, configura regras para mover/expirar versões antigas.

## Características

*   **Segurança Padrão:** Acesso público bloqueado, criptografia em repouso e trânsito forçado (SSL).
*   **Gerenciamento de Custos:** Regras de ciclo de vida para transição de versões antigas para Standard-IA e expiração.
*   **Versionamento:** Habilitado por padrão para proteção contra deleções acidentais.

## Uso Básico

```hcl
module "my_bucket" {
  source = "../../modules/storage/s3-bucket"

  bucket_name = "my-unique-bucket-name-12345"
}
```

## Exemplos

Consulte `examples/s3-bucket/` para exemplos detalhados.
*   [Basic](examples/s3-bucket/basic): Bucket simples seguro.
*   [Lifecycle](examples/s3-bucket/lifecycle): Bucket com regras de ciclo de vida para economia.

## Entradas (Inputs)

| Nome | Descrição | Tipo | Padrão | Obrigatório |
|------|-----------|------|--------|:-----------:|
| `bucket_name` | Nome único do bucket. | `string` | n/a | Sim |
| `versioning_enabled` | Habilitar versionamento. | `bool` | `true` | Não |
| `force_ssl` | Forçar uso de HTTPS. | `bool` | `true` | Não |
| `lifecycle_rule_enabled` | Habilitar regras de ciclo de vida. | `bool` | `false` | Não |
| `noncurrent_version_transition_days` | Dias para mover versões antigas para IA. | `number` | `30` | Não |
| `noncurrent_version_expiration_days` | Dias para apagar versões antigas. | `number` | `90` | Não |
| `tags` | Tags adicionais. | `map(string)` | `{}` | Não |

## Saídas (Outputs)

| Nome | Descrição |
|------|-----------|
| `bucket_id` | Nome do bucket. |
| `bucket_arn` | ARN do bucket. |
| `bucket_domain_name` | Domínio regional do bucket. |
