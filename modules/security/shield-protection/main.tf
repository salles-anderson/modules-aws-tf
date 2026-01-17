locals {
  tags = merge(
    {
      Project = var.project_name
    },
    var.tags,
  )
}

resource "aws_shield_protection" "this" {
  name              = var.protection_name
  resource_arn      = var.resource_arn
  health_check_arns = var.health_check_arns
}
