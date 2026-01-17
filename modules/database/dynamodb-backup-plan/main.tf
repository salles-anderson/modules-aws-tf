resource "aws_backup_vault" "this" {
  name = var.vault_name
  tags = merge(
    {
      "Project" = var.project_name
    },
    var.tags,
  )
}

resource "aws_backup_plan" "this" {
  name = var.plan_name
  tags = merge(
    {
      "Project" = var.project_name
    },
    var.tags,
  )

  rule {
    rule_name         = "daily-backups"
    target_vault_name = aws_backup_vault.this.name
    schedule          = "cron(0 5 * * ? *)" # Runs daily at 5:00 AM UTC

    lifecycle {
      delete_after = 60 # Retain backups for 60 days
    }
  }
}

resource "aws_backup_selection" "this" {
  iam_role_arn = var.iam_role_arn
  name         = var.selection_name
  plan_id      = aws_backup_plan.this.id

  resources = var.table_arns
}