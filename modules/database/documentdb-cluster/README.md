# DocumentDB Cluster Module

Provisiona um cluster Amazon DocumentDB com subnet group, instâncias, criptografia e snapshots configuráveis.

## Uso Básico

```hcl
module "documentdb" {
  source = "../../modules/database/documentdb-cluster"

  project_name         = "plataforma-assinatura"
  cluster_identifier   = "docdb-core"
  master_username      = "admin"
  master_password      = "senha-segura"
  subnet_ids           = ["subnet-a", "subnet-b"]
  vpc_security_group_ids = ["sg-123"]
}
```

## Inputs

| Nome | Descrição | Tipo | Padrão | Obrigatório |
|------|-----------|------|--------|:-----------:|
| `project_name` | Nome do projeto para taguear recursos. | `string` | n/a | Sim |
| `cluster_identifier` | Identificador do cluster DocumentDB. | `string` | n/a | Sim |
| `master_username` | Usuário administrador. | `string` | n/a | Sim |
| `master_password` | Senha do administrador. | `string` | n/a | Sim |
| `engine_version` | Versão do engine. | `string` | `"5.0"` | Não |
| `instance_class` | Classe das instâncias. | `string` | `"db.t3.medium"` | Não |
| `instance_count` | Quantidade de instâncias. | `number` | `2` | Não |
| `subnet_ids` | Subnets do subnet group. | `list(string)` | n/a | Sim |
| `vpc_security_group_ids` | Security Groups permitidos. | `list(string)` | n/a | Sim |
| `port` | Porta de conexão. | `number` | `27017` | Não |
| `backup_retention_period` | Dias de retenção de backup. | `number` | `7` | Não |
| `preferred_backup_window` | Janela de backup. | `string` | `"03:00-05:00"` | Não |
| `preferred_maintenance_window` | Janela de manutenção. | `string` | `null` | Não |
| `storage_encrypted` | Criptografia em repouso. | `bool` | `true` | Não |
| `kms_key_id` | KMS Key para criptografia. | `string` | `null` | Não |
| `apply_immediately` | Aplica mudanças imediatamente. | `bool` | `false` | Não |
| `deletion_protection` | Proteção contra deleção. | `bool` | `true` | Não |
| `skip_final_snapshot` | Pula snapshot final. | `bool` | `false` | Não |
| `final_snapshot_identifier` | Nome do snapshot final quando criado. | `string` | `null` | Não |
| `tags` | Mapa de tags adicionais. | `map(string)` | `{}` | Não |

## Outputs

| Nome | Descrição |
|------|-----------|
| `cluster_id` | ID do cluster DocumentDB. |
| `cluster_arn` | ARN do cluster. |
| `endpoint` | Endpoint principal. |
| `reader_endpoint` | Endpoint de leitura. |
| `instance_endpoints` | Endpoints das instâncias. |
