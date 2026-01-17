module "dynamo_range" {
  source = "../../../modules/database/dynamodb-table"

  project_name = "dynamo-range"
  table_name   = "ComplexTable"
  hash_key     = "PK"
  range_key    = "SK"

  attributes = [
    { name = "PK", type = "S" },
    { name = "SK", type = "N" }
  ]
}
