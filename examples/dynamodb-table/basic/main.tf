module "dynamo_basic" {
  source = "../../../modules/database/dynamodb-table"

  project_name = "dynamo-basic"
  table_name   = "SimpleTable"
  hash_key     = "ID"

  attributes = [
    { name = "ID", type = "S" }
  ]
}
