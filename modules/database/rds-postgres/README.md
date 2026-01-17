# RDS PostgreSQL Module

Este módulo provisiona uma instância RDS PostgreSQL na AWS, juntamente com o grupo de sub-redes associado.

## Arquitetura

O módulo cria:
*   `aws_db_subnet_group`: Grupo de sub-redes para a instância RDS.
*   `aws_db_instance`: A instância de banco de dados PostgreSQL.

## Características

*   Configuração padrão segura (criptografia ativada, acesso público desativado).
*   Suporte a Multi-AZ para alta disponibilidade.
*   Suporte a backups automáticos e snapshots finais.

## Uso Básico

```hcl
module "rds_postgres" {
  source = "../../modules/database/rds-postgres"

  project_name      = "my-project"
  identifier        = "my-db-postgres"
  instance_class    = "db.t3.micro"
  allocated_storage = 20
  db_name           = "mydb"
  username          = "postgres"
  password          = "ChangeMe123!"
  subnet_ids        = ["subnet-1", "subnet-2"]
  vpc_security_group_ids = ["sg-1"]
}
```

## Exemplos

Consulte `examples/rds-postgres/` para exemplos detalhados:
*   [Basic](examples/rds-postgres/basic): Exemplo simples (não recomendado para produção).
*   [Production](examples/rds-postgres/production): Exemplo Multi-AZ com criptografia e backup (recomendado).

## Entradas (Inputs)

| Nome | Descrição | Tipo | Padrão | Obrigatório |
|------|-----------|------|--------|:-----------:|
| `project_name` | Nome do projeto. | `string` | n/a | Sim |
| `identifier` | Identificador único da instância. | `string` | n/a | Sim |
| `instance_class` | Classe da instância (ex: db.t3.micro). | `string` | n/a | Sim |
| `allocated_storage` | Armazenamento (GB). | `number` | n/a | Sim |
| `db_name` | Nome do banco inicial. | `string` | n/a | Sim |
| `username` | Usuário mestre. | `string` | n/a | Sim |
| `password` | Senha mestre. | `string` | n/a | Sim |
| `subnet_ids` | IDs das sub-redes. | `list(string)` | n/a | Sim |
| `vpc_security_group_ids` | IDs dos Security Groups. | `list(string)` | n/a | Sim |
| `engine_version` | Versão do PostgreSQL. | `string` | `15.5` | Não |
| `multi_az` | Habilitar Multi-AZ. | `bool` | `true` | Não |
| `storage_encrypted` | Habilitar criptografia. | `bool` | `true` | Não |
| `publicly_accessible` | Acesso público. | `bool` | `false` | Não |
| `backup_retention_period` | Dias de retenção de backup. | `number` | `7` | Não |
| `skip_final_snapshot` | Pular snapshot final ao deletar. | `bool` | `false` | Não |
| `skip_final_snapshot_timestamp` | Identifier do snapshot final. | `string` | `false` | Não |
| `tags` | Tags adicionais. | `map(string)` | `{}` | Não |

## Saídas (Outputs)

| Nome | Descrição |
|------|-----------|
| `db_instance_address` | Endpoint da instância. |
| `db_instance_port` | Porta da instância. |
| `db_instance_id` | ID da instância. |
