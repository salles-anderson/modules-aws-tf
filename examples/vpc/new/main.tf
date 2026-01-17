module "vpc_new" {
  source = "../../../modules/networking/vpc"

  project_name = "vpc-new-demo"
  vpc_cidr     = "10.0.0.0/16"
  azs          = ["us-east-1a", "us-east-1b"]

  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  enable_flow_logs   = false
}

output "vpc_id" {
  value = module.vpc_new.vpc_id
}
