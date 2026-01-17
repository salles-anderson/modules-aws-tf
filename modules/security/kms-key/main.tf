locals {
  tags = merge(
    {
      Project = var.project_name
    },
    var.tags,
  )
}

resource "aws_kms_key" "this" {
  description             = var.description
  deletion_window_in_days = var.deletion_window_in_days
  enable_key_rotation     = var.enable_key_rotation
  is_enabled              = var.is_enabled
  multi_region            = var.multi_region
  policy                  = var.policy

  tags = merge(
    local.tags,
    {
      Name = coalesce(var.alias_name, "kms-key")
    },
  )
}

resource "aws_kms_alias" "this" {
  count         = var.alias_name != null ? 1 : 0
  name          = format("alias/%s", var.alias_name)
  target_key_id = aws_kms_key.this.key_id
}
