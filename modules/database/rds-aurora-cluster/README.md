# RDS Aurora Cluster Module

Módulo para provisionar um cluster Aurora (MySQL ou PostgreSQL) com instâncias writer/reader, export de logs, write forwarding (MySQL), Enhanced Monitoring e janelas de backup/manutenção.

## Recursos criados

* `aws_db_subnet_group`
* `aws_rds_cluster`
* `aws_rds_cluster_instance` (writer + readers)
* `aws_iam_role` (opcional) para Enhanced Monitoring

## Uso básico (Aurora MySQL)

```hcl
module "aurora_mysql" {
  source = "../../modules/database/rds-aurora-cluster"

  project_name           = "my-project"
  identifier             = "my-aurora-mysql"
  engine                 = "aurora-mysql"
  engine_version         = "8.0.mysql_aurora.3.08.2"
  instance_class         = "db.t3.medium"
  instance_count         = 2 # writer + 1 reader
  db_name                = "appdb"
  username               = "admin"
  password               = "ChangeMe!"
  subnet_ids             = ["subnet-a", "subnet-b"]
  vpc_security_group_ids = ["sg-123"]

  backup_retention_period         = 1
  preferred_backup_window         = "03:47-04:17"
  preferred_maintenance_window    = "sun:04:29-sun:04:59"
  enabled_cloudwatch_logs_exports = ["audit", "error", "slowquery"]
  enable_local_write_forwarding   = true
  deletion_protection             = true
  monitoring_interval             = 60
}
```

## Uso básico (Aurora PostgreSQL)

```hcl
module "aurora_pg" {
  source = "../../modules/database/rds-aurora-cluster"

  project_name           = "my-project"
  identifier             = "my-aurora-pg"
  engine                 = "aurora-postgresql"
  engine_version         = "15.4"
  instance_class         = "db.r6g.large"
  instance_count         = 2
  db_name                = "appdb"
  username               = "admin"
  password               = "ChangeMe!"
  subnet_ids             = ["subnet-a", "subnet-b"]
  vpc_security_group_ids = ["sg-123"]

  enabled_cloudwatch_logs_exports = ["postgresql"]
  monitoring_interval             = 0 # sem Enhanced Monitoring
}
```

## Inputs principais

| Nome | Descrição | Tipo | Padrão |
|------|-----------|------|--------|
| `project_name` | Nome do projeto para tags. | `string` | n/a |
| `identifier` | Identificador do cluster. | `string` | n/a |
| `engine` | `aurora-mysql` ou `aurora-postgresql`. | `string` | `aurora-mysql` |
| `engine_version` | Versão do engine (null usa default AWS). | `string` | `null` |
| `instance_class` | Classe das instâncias. | `string` | n/a |
| `instance_count` | Quantidade de instâncias (writer + readers). | `number` | `2` |
| `db_name` | Nome do DB inicial. | `string` | `null` |
| `username` | Usuário mestre. | `string` | n/a |
| `password` | Senha mestre. | `string` | n/a |
| `subnet_ids` | Subnets para o subnet group. | `list(string)` | n/a |
| `vpc_security_group_ids` | Security Groups associados. | `list(string)` | n/a |
| `backup_retention_period` | Dias de retenção de backup. | `number` | `7` |
| `preferred_backup_window` | Janela de backup. | `string` | `null` |
| `preferred_maintenance_window` | Janela de manutenção. | `string` | `null` |
| `enabled_cloudwatch_logs_exports` | Logs exportados (MySQL: `audit`, `error`, `slowquery`; PG: `postgresql`). | `list(string)` | `[]` |
| `enable_local_write_forwarding` | Write forwarding (Aurora MySQL). | `bool` | `true` |
| `monitoring_interval` | Enhanced Monitoring em segundos (`0` desliga). | `number` | `0` |
| `monitoring_role_arn` | ARN da role de Enhanced Monitoring (se já existir). | `string` | `null` |
| `deletion_protection` | Proteção contra deleção. | `bool` | `false` |
| `apply_immediately` | Aplica mudanças imediatamente. | `bool` | `false` |
| `skip_final_snapshot` | Pula snapshot final ao destruir. | `bool` | `false` |
| `final_snapshot_identifier` | Identificador do snapshot final. | `string` | `null` |

## Outputs

| Nome | Descrição |
|------|-----------|
| `cluster_id` | ID do cluster. |
| `cluster_arn` | ARN do cluster. |
| `writer_endpoint` | Endpoint writer. |
| `reader_endpoint` | Endpoint de leitura. |
| `port` | Porta de conexão. |
| `subnet_group_name` | DB subnet group. |
| `instance_ids` | IDs das instâncias. |
| `instance_endpoints` | Endpoints individuais. |
| `monitoring_role_arn` | Role usada no Enhanced Monitoring. |

