# SQS Queue Module

Cria uma fila SQS com DLQ opcional, suporte a FIFO, criptografia e long polling configurável.

## Uso Básico

```hcl
module "queue" {
  source = "../../modules/serverless/sqs-queue"

  project_name = "plataforma-assinatura"
  queue_name   = "events"
}
```

## Inputs

| Nome | Descrição | Tipo | Padrão | Obrigatório |
|------|-----------|------|--------|:-----------:|
| `project_name` | Nome do projeto para taguear recursos. | `string` | n/a | Sim |
| `queue_name` | Nome da fila. Para FIFO, terminar com `.fifo`. | `string` | n/a | Sim |
| `fifo_queue` | Define se a fila é FIFO. | `bool` | `false` | Não |
| `content_based_deduplication` | Deduplicação por conteúdo (FIFO). | `bool` | `true` | Não |
| `delay_seconds` | Atraso padrão. | `number` | `0` | Não |
| `max_message_size` | Tamanho máximo da mensagem. | `number` | `262144` | Não |
| `message_retention_seconds` | Retenção das mensagens. | `number` | `345600` | Não |
| `receive_wait_time_seconds` | Long polling (s). | `number` | `0` | Não |
| `visibility_timeout_seconds` | Tempo de invisibilidade após leitura. | `number` | `30` | Não |
| `kms_master_key_id` | KMS Key para criptografia. | `string` | `null` | Não |
| `dlq_enabled` | Se `true`, cria DLQ e redrive. | `bool` | `false` | Não |
| `dlq_max_receive_count` | Recebimentos antes de enviar à DLQ. | `number` | `5` | Não |
| `dlq_message_retention_seconds` | Retenção das mensagens na DLQ. | `number` | `1209600` | Não |
| `tags` | Mapa de tags adicionais. | `map(string)` | `{}` | Não |

## Outputs

| Nome | Descrição |
|------|-----------|
| `queue_id` | ID da fila. |
| `queue_arn` | ARN da fila. |
| `queue_url` | URL da fila. |
| `dlq_arn` | ARN da DLQ criada. |
