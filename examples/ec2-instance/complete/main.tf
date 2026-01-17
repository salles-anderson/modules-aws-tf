module "ec2_complete" {
  source = "../../../modules/compute/ec2-instance"

  project_name                = "example-complete"
  instance_name               = "example-instance-complete"
  ami_id                      = "ami-0123456789abcdef0" # Dummy AMI ID
  instance_type               = "t3.medium"
  subnet_id                   = "subnet-0123456789abcdef0" # Dummy Subnet ID
  key_name                    = "my-key-pair"
  vpc_security_group_ids      = ["sg-0123456789abcdef0"]
  associate_public_ip_address = true
  iam_instance_profile        = "my-iam-profile"

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World!" > /tmp/hello.txt
              EOF

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}

output "instance_public_ip" {
  value = module.ec2_complete.public_ip
}
