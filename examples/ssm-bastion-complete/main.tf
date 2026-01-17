# ======================================================================================
# ARQUIVO DE CONFIGURAÇÃO PRINCIPAL - Exemplo de SSM Bastion
# ======================================================================================
# Este arquivo contém a definição dos recursos para criar uma infraestrutura de bastion
# segura, utilizando os módulos de VPC e SSM Bastion.
# ======================================================================================

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.0"
}

provider "aws" {
  region = var.aws_region
}

# --------------------------------------------------------------------------------------
# MÓDULO DE REDE (VPC)
# --------------------------------------------------------------------------------------
# Cria uma VPC completa com sub-redes públicas e privadas, Internet Gateway e
# um NAT Gateway. O NAT Gateway é essencial para permitir que o bastion em uma
# sub-rede privada acesse os endpoints do AWS SSM.
# --------------------------------------------------------------------------------------
module "network" {
  source = "../../modules/vpc"

  project_name = var.project_name
  create_vpc   = true

  vpc_cidr        = "10.0.0.0/16"
  azs             = ["${var.aws_region}a", "${var.aws_region}b"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.101.0/24", "10.0.102.0/24"]

  # Habilita o NAT Gateway para dar acesso à internet para as sub-redes privadas
  enable_nat_gateway = true

  tags = {
    Terraform   = "true"
    Environment = "Example"
  }
}

# --------------------------------------------------------------------------------------
# MÓDULO DO BASTION (SSM)
# --------------------------------------------------------------------------------------
# Cria a instância EC2 que servirá como bastion.
# - É colocada em uma sub-rede privada para segurança.
# - Não possui IP público.
# - O acesso é feito exclusivamente via AWS Systems Manager (SSM).
# --------------------------------------------------------------------------------------
module "ssm_bastion" {
  source = "../../modules/ssm-bastion"

  project_name = var.project_name
  name         = "${var.project_name}-bastion"
  vpc_id       = module.network.vpc_id
  subnet_id    = module.network.private_subnet_ids[0] # Usa a primeira sub-rede privada

  instance_type = "t3.micro" # t3.nano pode ser muito lento para algumas AMIs

  tags = {
    Terraform   = "true"
    Environment = "Example"
  }
}
