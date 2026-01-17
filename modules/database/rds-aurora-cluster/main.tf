locals {
  tags = merge(
    {
      Project = var.project_name
    },
    var.tags,
  )

  port = coalesce(
    var.port,
    var.engine == "aurora-postgresql" ? 5432 : 3306
  )

  monitoring_role_needed  = var.monitoring_interval > 0 && var.monitoring_role_arn == null && var.create_monitoring_role
  monitoring_role_name    = coalesce(var.monitoring_role_name, "${var.identifier}-rds-monitoring")
  enable_write_forwarding = var.engine == "aurora-mysql" ? var.enable_local_write_forwarding : null
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.identifier}-sng"
  subnet_ids = var.subnet_ids

  tags = merge(
    local.tags,
    { Name = "${var.identifier}-sng" },
  )
}

resource "aws_iam_role" "monitoring" {
  count = local.monitoring_role_needed ? 1 : 0

  name = local.monitoring_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "monitoring.rds.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "monitoring" {
  count = length(aws_iam_role.monitoring)

  role       = aws_iam_role.monitoring[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

locals {
  monitoring_role_arn = var.monitoring_interval > 0 ? coalesce(
    var.monitoring_role_arn,
    try(aws_iam_role.monitoring[0].arn, null),
  ) : null
}

resource "aws_rds_cluster" "this" {
  cluster_identifier              = var.identifier
  engine                          = var.engine
  engine_version                  = var.engine_version
  database_name                   = var.db_name
  master_username                 = var.username
  master_password                 = var.password
  port                            = local.port
  db_subnet_group_name            = aws_db_subnet_group.this.name
  vpc_security_group_ids          = var.vpc_security_group_ids
  db_cluster_parameter_group_name = var.cluster_parameter_group_name
  storage_encrypted               = var.storage_encrypted
  backup_retention_period         = var.backup_retention_period
  preferred_backup_window         = var.preferred_backup_window
  preferred_maintenance_window    = var.preferred_maintenance_window
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  enable_local_write_forwarding   = local.enable_write_forwarding
  deletion_protection             = var.deletion_protection
  apply_immediately               = var.apply_immediately
  copy_tags_to_snapshot           = true
  skip_final_snapshot             = var.skip_final_snapshot
  final_snapshot_identifier       = var.final_snapshot_identifier

  tags = merge(
    local.tags,
    { Name = var.identifier },
  )
}

resource "aws_rds_cluster_instance" "this" {
  count = var.instance_count

  identifier                            = format("%s-%02d", var.identifier, count.index + 1)
  cluster_identifier                    = aws_rds_cluster.this.id
  instance_class                        = var.instance_class
  engine                                = var.engine
  engine_version                        = var.engine_version
  publicly_accessible                   = var.publicly_accessible
  db_subnet_group_name                  = aws_db_subnet_group.this.name
  db_parameter_group_name               = var.instance_parameter_group_name
  monitoring_interval                   = var.monitoring_interval
  monitoring_role_arn                   = local.monitoring_role_arn
  auto_minor_version_upgrade            = var.auto_minor_version_upgrade
  apply_immediately                     = var.apply_immediately
  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_retention_period
  performance_insights_kms_key_id       = var.performance_insights_kms_key_id

  tags = merge(
    local.tags,
    { Name = format("%s-%02d", var.identifier, count.index + 1) },
  )
}
