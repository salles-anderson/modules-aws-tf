locals {
  lifecycle_policy_json = length(var.lifecycle_rules) == 0 ? null : jsonencode({
    rules = [
      for rule in var.lifecycle_rules : merge(
        {
          rulePriority = rule.priority
          selection = merge(
            {
              tagStatus   = rule.selection.tag_status
              countType   = rule.selection.count_type
              countNumber = rule.selection.count_number
            },
            rule.selection.count_unit == null ? {} : { countUnit = rule.selection.count_unit },
            rule.selection.tag_prefixes == null ? {} : { tagPrefixList = rule.selection.tag_prefixes },
          )
          action = {
            type = rule.action.type
          }
        },
        rule.description == null ? {} : { description = rule.description }
      )
    ]
  })
}

resource "aws_ecr_repository" "this" {
  name                 = var.name
  image_tag_mutability = var.image_tag_mutability
  force_delete         = var.force_delete

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  encryption_configuration {
    encryption_type = var.encryption_type
    kms_key         = var.encryption_type == "KMS" ? var.kms_key_arn : null
  }

  tags = var.tags
}

resource "aws_ecr_lifecycle_policy" "this" {
  count = local.lifecycle_policy_json == null ? 0 : 1

  repository = aws_ecr_repository.this.name
  policy     = local.lifecycle_policy_json
}

resource "aws_ecr_repository_policy" "this" {
  count = var.repository_policy_json == null ? 0 : 1

  repository = aws_ecr_repository.this.name
  policy     = var.repository_policy_json
}
