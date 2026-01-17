locals {
  tags = merge(
    {
      Project = var.project_name
    },
    var.tags,
  )
}

resource "aws_docdb_subnet_group" "this" {
  name       = "${var.cluster_identifier}-sng"
  subnet_ids = var.subnet_ids

  tags = merge(
    local.tags,
    {
      Name = "${var.cluster_identifier}-sng"
    },
  )
}

resource "aws_docdb_cluster" "this" {
  cluster_identifier           = var.cluster_identifier
  master_username              = var.master_username
  master_password              = var.master_password
  engine_version               = var.engine_version
  storage_encrypted            = var.storage_encrypted
  kms_key_id                   = var.kms_key_id
  backup_retention_period      = var.backup_retention_period
  preferred_backup_window      = var.preferred_backup_window
  db_subnet_group_name         = aws_docdb_subnet_group.this.name
  vpc_security_group_ids       = var.vpc_security_group_ids
  port                         = var.port
  apply_immediately            = var.apply_immediately
  deletion_protection          = var.deletion_protection
  skip_final_snapshot          = var.skip_final_snapshot
  final_snapshot_identifier    = var.skip_final_snapshot ? null : coalesce(var.final_snapshot_identifier, "${var.cluster_identifier}-final")
  preferred_maintenance_window = var.preferred_maintenance_window

  tags = merge(
    local.tags,
    {
      Name = var.cluster_identifier
    },
  )
}

resource "aws_docdb_cluster_instance" "this" {
  count = var.instance_count

  identifier         = format("%s-%02d", var.cluster_identifier, count.index + 1)
  cluster_identifier = aws_docdb_cluster.this.id
  instance_class     = var.instance_class
  apply_immediately  = var.apply_immediately
}
