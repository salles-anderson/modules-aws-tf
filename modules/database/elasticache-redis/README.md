# ElastiCache Redis Module

Provisiona um Redis gerenciado (ElastiCache) com subnet group, replicação e criptografia habilitada.

## Uso Básico

```hcl
module "redis" {
  source = "../../modules/database/elasticache-redis"

  project_name          = "plataforma-assinatura"
  replication_group_id  = "redis-core"
  subnet_ids            = ["subnet-a", "subnet-b"]
  security_group_ids    = ["sg-123"]
}
```

## Inputs

| Nome | Descrição | Tipo | Padrão | Obrigatório |
|------|-----------|------|--------|:-----------:|
| `project_name` | Nome do projeto para taguear recursos. | `string` | n/a | Sim |
| `replication_group_id` | Identificador do replication group Redis. | `string` | n/a | Sim |
| `description` | Descrição do cluster. | `string` | `"Redis cluster gerenciado"` | Não |
| `engine_version` | Versão do Redis. | `string` | `"7.1"` | Não |
| `node_type` | Classe da instância de cache. | `string` | `"cache.t3.small"` | Não |
| `num_cache_clusters` | Número de nós (modo não clusterizado). | `number` | `2` | Não |
| `port` | Porta de conexão. | `number` | `6379` | Não |
| `maintenance_window` | Janela de manutenção. | `string` | `null` | Não |
| `snapshot_window` | Janela de snapshot. | `string` | `null` | Não |
| `snapshot_retention_limit` | Dias de retenção de snapshot. | `number` | `7` | Não |
| `subnet_ids` | Subnets onde o Redis será implantado. | `list(string)` | n/a | Sim |
| `security_group_ids` | Security Groups com acesso ao Redis. | `list(string)` | n/a | Sim |
| `parameter_group_name` | Parameter group a associar. | `string` | `null` | Não |
| `apply_immediately` | Aplica alterações imediatamente. | `bool` | `false` | Não |
| `at_rest_encryption_enabled` | Criptografia em repouso. | `bool` | `true` | Não |
| `transit_encryption_enabled` | Criptografia em trânsito (TLS). | `bool` | `true` | Não |
| `auth_token` | Token de autenticação. | `string` | `null` | Não |
| `multi_az_enabled` | Habilita Multi-AZ. | `bool` | `true` | Não |
| `automatic_failover_enabled` | Failover automático. | `bool` | `true` | Não |
| `preferred_cache_cluster_azs` | AZs preferidas para cada nó. | `list(string)` | `[]` | Não |
| `kms_key_id` | KMS Key para criptografia em repouso. | `string` | `null` | Não |
| `tags` | Mapa de tags adicionais. | `map(string)` | `{}` | Não |

## Outputs

| Nome | Descrição |
|------|-----------|
| `replication_group_id` | ID do replication group. |
| `primary_endpoint` | Endpoint primário. |
| `reader_endpoint` | Endpoint de leitura. |
| `port` | Porta do Redis. |
