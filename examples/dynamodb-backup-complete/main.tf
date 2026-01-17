terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

data "aws_caller_identity" "current" {}

module "dynamodb_tabela_teste" {
  source = "../../modules/database/dynamodb-table"

  project_name = "ExemploBackup"
  table_name   = "tabela-teste-backup"
  hash_key     = "id"

  attributes = [
    {
      name = "id"
      type = "S"
    }
  ]

  tags = {
    "Ambiente" = "Teste"
  }
}

module "backup_plano_teste" {
  source = "../../modules/database/dynamodb-backup-plan"

  project_name   = "ExemploBackup"
  vault_name     = "exemplo-vault-dynamodb"
  plan_name      = "exemplo-plano-backup-dynamodb"
  selection_name = "exemplo-selecao-tabelas"
  iam_role_arn   = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/service-role/AWSBackupDefaultServiceRole"
  table_arns     = [module.dynamodb_tabela_teste.table_arn]

  tags = {
    "Ambiente" = "Teste"
  }
}

output "tabela_arn" {
  description = "ARN da tabela DynamoDB de teste."
  value       = module.dynamodb_tabela_teste.table_arn
}

output "plano_backup_id" {
  description = "ID do plano de backup de teste."
  value       = module.backup_plano_teste.backup_plan_id
}