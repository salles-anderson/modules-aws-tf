# Touched to include in patch
locals {
  tags = merge(
    {
      "Project" = var.project_name
    },
    var.tags,
  )
  # Se nenhuma AMI for fornecida, busca a mais recente do Amazon Linux 2
  ami_id = var.ami_id != null ? var.ami_id : data.aws_ami.amazon_linux.id
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# --- IAM Role para permitir que o SSM gerencie a instância ---
resource "aws_iam_role" "this" {
  name = "${var.name}-role"
  path = "/"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "ssm_managed_core" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "this" {
  name = "${var.name}-instance-profile"
  role = aws_iam_role.this.name
}

# --- Security Group para a instância bastion ---
# Por padrão, não permite nenhuma entrada (ingress). A conexão é feita via SSM.
resource "aws_security_group" "this" {
  name        = "${var.name}-sg"
  description = "Security Group for SSM Bastion"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.tags,
    {
      "Name" = "${var.name}-sg"
    }
  )
}

# --- Instância EC2 ---
resource "aws_instance" "this" {
  ami           = local.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id

  iam_instance_profile        = aws_iam_instance_profile.this.name
  vpc_security_group_ids      = [aws_security_group.this.id]
  associate_public_ip_address = false # Não precisa de IP público

  tags = merge(
    local.tags,
    {
      "Name" = var.name
    }
  )
}