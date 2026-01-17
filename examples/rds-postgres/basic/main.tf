module "rds_postgres_basic" {
  source = "../../../modules/database/rds-postgres"

  project_name           = "postgres-basic"
  identifier             = "postgres-basic-instance"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  db_name                = "appdb"
  username               = "postgres"
  password               = "SuperSecret123!"
  subnet_ids             = ["subnet-1", "subnet-2"]
  vpc_security_group_ids = ["sg-1"]

  multi_az            = false
  skip_final_snapshot = true
}

output "endpoint" {
  value = module.rds_postgres_basic.db_instance_address
}
