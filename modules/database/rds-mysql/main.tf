locals {
  tags = merge(
    {
      "Project" = var.project_name
    },
    var.tags,
  )
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.identifier}-sng"
  subnet_ids = var.subnet_ids

  tags = merge(
    local.tags,
    {
      "Name" = "${var.identifier}-sng"
    }
  )
}

resource "aws_db_instance" "this" {
  identifier                = var.identifier
  engine                    = "mysql"
  engine_version            = var.engine_version
  instance_class            = var.instance_class
  allocated_storage         = var.allocated_storage
  storage_type              = var.storage_type
  storage_encrypted         = var.storage_encrypted
  db_name                   = var.db_name
  username                  = var.username
  password                  = var.password
  db_subnet_group_name      = aws_db_subnet_group.this.name
  vpc_security_group_ids    = var.vpc_security_group_ids
  parameter_group_name      = var.parameter_group_name
  multi_az                  = var.multi_az
  publicly_accessible       = var.publicly_accessible
  backup_retention_period   = var.backup_retention_period
  final_snapshot_identifier = var.skip_final_snapshot_timestamp
  skip_final_snapshot       = var.skip_final_snapshot
  apply_immediately         = false # Recomenda-se `false` para produção

  tags = merge(
    local.tags,
    {
      "Name" = var.identifier
    }
  )
}
