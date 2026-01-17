module "rds_postgres_prod" {
  source = "../../../modules/database/rds-postgres"

  project_name           = "postgres-prod"
  identifier             = "postgres-prod-instance"
  instance_class         = "db.t3.medium"
  allocated_storage      = 50
  db_name                = "proddb"
  username               = "postgres"
  password               = "SuperSecretProd123!"
  subnet_ids             = ["subnet-1", "subnet-2"]
  vpc_security_group_ids = ["sg-1"]

  multi_az                      = true
  storage_encrypted             = true
  backup_retention_period       = 30
  skip_final_snapshot           = false
  skip_final_snapshot_timestamp = "postgres-prod-final-snapshot"
}

output "endpoint" {
  value = module.rds_postgres_prod.db_instance_address
}
