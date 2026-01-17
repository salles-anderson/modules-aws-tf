module "sg_source" {
  source = "../../../modules/security/security-group"

  project_name = "sg-inter-demo"
  name         = "app-sg"
  vpc_id       = "vpc-0123456789abcdef0" # Dummy VPC
}

module "sg_db" {
  source = "../../../modules/security/security-group"

  project_name = "sg-inter-demo"
  name         = "db-sg"
  vpc_id       = "vpc-0123456789abcdef0" # Dummy VPC

  ingress_rules = [
    {
      from_port                = 3306
      to_port                  = 3306
      protocol                 = "tcp"
      source_security_group_id = module.sg_source.id
      description              = "Allow App SG"
    }
  ]
}
