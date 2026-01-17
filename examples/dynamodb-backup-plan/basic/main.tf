module "backup" {
  source = "../../../modules/database/dynamodb-backup-plan"

  project_name   = "backup-demo"
  vault_name     = "dynamo-vault-demo"
  plan_name      = "dynamo-plan-demo"
  selection_name = "dynamo-selection-demo"
  iam_role_arn   = "arn:aws:iam::123456789012:role/service-role/AWSBackupDefaultServiceRole" # Dummy Role
  table_arns     = ["arn:aws:dynamodb:us-east-1:123456789012:table/dummy-table"]             # Dummy Table ARN
}
