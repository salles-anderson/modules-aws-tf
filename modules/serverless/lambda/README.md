# Lambda Module

Módulo Terraform opinado para criação de uma função AWS Lambda com empacotamento local (`archive_file`) ou reaproveitando um pacote hospedado em S3. Também oferece suporte opcional à associação com uma VPC e criação automática de Security Group/Log Group.

## Variáveis principais

| Variável                              | Descrição                                                             |
| ------------------------------------- | --------------------------------------------------------------------- |
| `project_name`                        | Nome do projeto usado em tags.                                        |
| `lambda_function_name`                | Nome da função Lambda.                                                |
| `lambda_source_dir`                   | Caminho com o código a ser zipado (padrão: `./src`).                  |
| `api_url`                             | Endpoint configurado como variável de ambiente `API_URL`.             |
| `api_secret_name`                     | Nome/ARN opcional exposto como variável `API_SECRET_ARN`.             |
| `lambda_package_s3_*`                 | Permite reutilizar um ZIP existente em S3 no lugar do `archive_file`. |
| `environment_variables`               | Mapa com variáveis de ambiente.                                       |
| `lambda_vpc_id` / `lambda_subnet_ids` | Configuram a Lambda dentro de uma VPC.                                |
| `lambda_security_group_ids`           | Usa SGs existentes. Quando vazio, o módulo cria um SG padrão.         |

## Exemplo de uso

```hcl
module "lambda" {
  source = "git@github.com:TeckSolucoes/terraform-aws-modules.git//modules/serverless/lambda?ref=v1.0.0"

  project_name         = "frontconsig"
  lambda_function_name = "frontconsig-lambda-eventbridge-api-homolog"
  lambda_source_dir    = abspath("../../frontconsig-lambda-eventbrigde-api/src")

  environment_variables = {
    ENVIRONMENT = "homolog"
  }

  lambda_vpc_id     = "vpc-0a8fd9b8a17d68f46"
  lambda_subnet_ids = ["subnet-0a6bb1ccc1697c0b8", "subnet-0c97f96c01c5ec1a5"]
}
```

O módulo expõe os outputs `lambda_function_arn`, `lambda_function_name`, `lambda_role_arn` e `lambda_security_group_ids`, que podem ser consumidos por outros módulos (como o EventBridge Scheduler).\*\*\* End Patch
