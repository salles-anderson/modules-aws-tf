module "sg_basic" {
  source = "../../../modules/security/security-group"

  project_name = "sg-basic-demo"
  name         = "web-sg"
  vpc_id       = "vpc-0123456789abcdef0" # Dummy VPC

  ingress_rules = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "HTTP"
    }
  ]
}

output "sg_id" {
  value = module.sg_basic.id
}
