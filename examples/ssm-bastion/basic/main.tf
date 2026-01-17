module "ssm_bastion" {
  source = "../../../modules/security/ssm-bastion"

  project_name = "ssm-bastion-demo"
  vpc_id       = "vpc-0123456789abcdef0"    # Dummy VPC
  subnet_id    = "subnet-0123456789abcdef0" # Dummy Subnet
}

output "instance_id" {
  value = module.ssm_bastion.instance_id
}
