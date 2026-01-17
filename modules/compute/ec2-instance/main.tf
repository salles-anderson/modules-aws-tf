locals {
  tags = merge(
    {
      "Project" = var.project_name
    },
    var.tags,
  )
}

resource "aws_instance" "this" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  key_name                    = var.key_name
  vpc_security_group_ids      = var.vpc_security_group_ids
  associate_public_ip_address = var.associate_public_ip_address
  user_data                   = var.user_data
  iam_instance_profile        = var.iam_instance_profile

  tags = merge(
    local.tags,
    {
      "Name" = var.instance_name
    }
  )
}