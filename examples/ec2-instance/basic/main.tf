module "ec2_basic" {
  source = "../../../modules/compute/ec2-instance"

  project_name  = "example-basic"
  instance_name = "example-instance"
  ami_id        = "ami-0123456789abcdef0" # Dummy AMI ID
  instance_type = "t3.micro"
  subnet_id     = "subnet-0123456789abcdef0" # Dummy Subnet ID
}

output "instance_id" {
  value = module.ec2_basic.id
}
