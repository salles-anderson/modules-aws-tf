locals {
  tags = merge(
    {
      "Project" = var.project_name
      "Cluster" = var.cluster_name
      "Role"    = var.rke2_role
    },
    var.tags,
  )
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "template_file" "rke2_install_script" {
  template = file("${path.module}/scripts/install_rke2.sh.tpl")

  vars = {
    rke2_version = var.rke2_version
    rke2_role    = var.rke2_role
    rke2_token   = var.rke2_token
  }
}

resource "aws_instance" "rke2_node" {
  count         = var.instance_count
  ami           = coalesce(var.ami_id, data.aws_ami.ubuntu.id)
  instance_type = var.instance_type

  # Distribui as instâncias ciclicamente pelas sub-redes fornecidas
  subnet_id = var.subnet_ids[count.index % length(var.subnet_ids)]

  vpc_security_group_ids = var.security_group_ids
  iam_instance_profile   = var.iam_instance_profile_name
  key_name               = var.key_name
  user_data_base64       = base64encode(data.template_file.rke2_install_script.rendered)

  root_block_device {
    volume_size = var.root_volume_size
    volume_type = "gp3"
    encrypted   = true
  }

  # Habilita IMDSv2 para segurança
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
  }

  # Configuração de auto-recuperação
  instance_initiated_shutdown_behavior = "terminate"

  tags = merge(
    local.tags,
    {
      "Name" = format("%s-%s-%02d", var.cluster_name, var.rke2_role, count.index + 1)
    }
  )
}