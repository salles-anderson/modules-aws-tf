module "vpc_existing" {
  source = "../../../modules/networking/vpc"

  create_vpc      = false
  project_name    = "vpc-existing-demo"
  vpc_id_existing = "vpc-0123456789abcdef0" # Dummy VPC ID

  public_subnet_tags_existing = {
    "Tier" = "Public"
  }
  private_subnet_tags_existing = {
    "Tier" = "Private"
  }
}

output "vpc_id" {
  value = module.vpc_existing.vpc_id
}
