# CloudTrail Module

Cria um CloudTrail multi-região com validação de logs, integração opcional com CloudWatch e bucket dedicado para armazenamento.

## Uso Básico

```hcl
module "cloudtrail" {
  source = "../../modules/security/cloudtrail"

  project_name   = "plataforma-assinatura"
  trail_name     = "org-trail"
  s3_bucket_name = "org-cloudtrail-logs"
}
```

## Inputs

| Nome | Descrição | Tipo | Padrão | Obrigatório |
|------|-----------|------|--------|:-----------:|
| `project_name` | Nome do projeto para taguear recursos. | `string` | n/a | Sim |
| `trail_name` | Nome do CloudTrail. | `string` | n/a | Sim |
| `s3_bucket_name` | Bucket onde os logs serão gravados. | `string` | n/a | Sim |
| `create_s3_bucket` | Se `true`, cria o bucket informado. | `bool` | `true` | Não |
| `s3_encryption_type` | Tipo de criptografia do bucket (`AES256` ou `aws:kms`). | `string` | `"AES256"` | Não |
| `s3_kms_key_id` | KMS Key do bucket quando `aws:kms`. | `string` | `null` | Não |
| `include_global_service_events` | Captura eventos de serviços globais. | `bool` | `true` | Não |
| `is_multi_region_trail` | Registra eventos de todas as regiões. | `bool` | `true` | Não |
| `enable_log_file_validation` | Habilita validação de integridade. | `bool` | `true` | Não |
| `kms_key_id` | KMS Key para criptografia do CloudTrail. | `string` | `null` | Não |
| `cloud_watch_logs_group_arn` | ARN do Log Group para logs em CloudWatch. | `string` | `null` | Não |
| `cloud_watch_logs_role_arn` | ARN da role para publicar no CloudWatch Logs. | `string` | `null` | Não |
| `is_organization_trail` | Cria trail da organização. | `bool` | `false` | Não |
| `tags` | Mapa de tags adicionais. | `map(string)` | `{}` | Não |

## Outputs

| Nome | Descrição |
|------|-----------|
| `trail_arn` | ARN do CloudTrail. |
| `trail_home_region` | Região principal do trail. |
| `trail_id` | ID do CloudTrail. |
