# DynamoDB Backup Plan Module

Este módulo configura um plano de backup no AWS Backup especificamente voltado para tabelas DynamoDB. Ele cria um cofre (Vault) e um plano de backup com retenção e agendamento pré-definidos.

## Arquitetura

O módulo cria:
*   `aws_backup_vault`: Cofre onde os backups serão armazenados.
*   `aws_backup_plan`: Define a rotina de backup (ex: diário às 05:00 UTC, retenção de 60 dias).
*   `aws_backup_selection`: Associa o plano às tabelas DynamoDB especificadas via ARN.

## Uso Básico

```hcl
module "dynamo_backup" {
  source = "../../modules/database/dynamodb-backup-plan"

  project_name  = "my-project"
  vault_name    = "my-dynamo-vault"
  plan_name     = "my-dynamo-plan"
  selection_name = "my-tables-selection"
  iam_role_arn  = "arn:aws:iam::123456789012:role/service-role/AWSBackupDefaultServiceRole"
  table_arns    = ["arn:aws:dynamodb:us-east-1:123456789012:table/my-table"]
}
```

## Exemplos

Consulte `examples/dynamodb-backup-plan/` para exemplos detalhados.
*   [Basic](examples/dynamodb-backup-plan/basic): Exemplo simples de configuração de backup.

## Entradas (Inputs)

| Nome | Descrição | Tipo | Padrão | Obrigatório |
|------|-----------|------|--------|:-----------:|
| `project_name` | Nome do projeto. | `string` | n/a | Sim |
| `vault_name` | Nome do AWS Backup Vault. | `string` | n/a | Sim |
| `plan_name` | Nome do AWS Backup Plan. | `string` | n/a | Sim |
| `selection_name` | Nome da seleção de backup. | `string` | n/a | Sim |
| `iam_role_arn` | ARN da IAM Role para AWS Backup. | `string` | n/a | Sim |
| `table_arns` | Lista de ARNs das tabelas DynamoDB. | `list(string)` | n/a | Sim |
| `tags` | Tags adicionais. | `map(string)` | `{}` | Não |

## Saídas (Outputs)

| Nome | Descrição |
|------|-----------|
| `backup_plan_id` | ID do plano de backup. |
| `backup_vault_name` | Nome do cofre de backup. |
| `backup_vault_arn` | ARN do cofre de backup. |
