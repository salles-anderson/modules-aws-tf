locals {
  tags = merge(
    {
      Project = var.project_name
    },
    var.tags,
  )
}

resource "aws_amplify_app" "this" {
  name                          = var.app_name
  repository                    = var.repository != null ? var.repository : null
  oauth_token                   = var.oauth_token != null ? var.oauth_token : null
  iam_service_role_arn          = var.iam_service_role_arn
  platform                      = var.platform
  enable_auto_branch_creation   = var.enable_auto_branch_creation
  auto_branch_creation_patterns = var.auto_branch_creation_patterns
  build_spec                    = var.build_spec
  basic_auth_credentials        = var.basic_auth_credentials
  access_token                  = var.access_token != null ? var.access_token : null

  environment_variables = var.environment_variables

  dynamic "custom_rule" {
    for_each = var.custom_rules
    content {
      source    = custom_rule.value.source
      target    = custom_rule.value.target
      status    = custom_rule.value.status
      condition = lookup(custom_rule.value, "condition", null)
    }
  }

  tags = merge(
    local.tags,
    {
      Name = var.app_name
    },
  )
}

resource "aws_amplify_branch" "this" {
  count = var.create_branch ? 1 : 0

  app_id      = aws_amplify_app.this.id
  branch_name = var.branch_name
  stage       = var.branch_stage
  tags        = local.tags
}
