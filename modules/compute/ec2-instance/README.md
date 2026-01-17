# EC2 Instance Module

Este módulo provisiona uma instância EC2 na AWS. Ele simplifica a criação de instâncias, aplicando tags padronizadas e configurações padrão seguras.

## Arquitetura

O módulo cria o recurso `aws_instance`.

## Uso Básico

```hcl
module "web_server" {
  source = "../../modules/compute/ec2-instance"

  project_name  = "meu-projeto"
  instance_name = "web-server-01"
  ami_id        = "ami-0c55b159cbfafe1f0"
  instance_type = "t3.micro"
  subnet_id     = "subnet-12345678"
}
```

## Exemplos

Consulte o diretório `examples/ec2-instance/` para exemplos completos:

*   [Basic](examples/ec2-instance/basic): Exemplo simples com apenas os parâmetros obrigatórios.
*   [Complete](examples/ec2-instance/complete): Exemplo com Security Groups, IAM Profile, User Data e IP Público.

## Entradas (Inputs)

| Nome | Descrição | Tipo | Padrão | Obrigatório |
|------|-----------|------|--------|:-----------:|
| `project_name` | Nome do projeto para taguear os recursos. | `string` | n/a | Sim |
| `instance_name` | Valor para a tag 'Name' da instância. | `string` | n/a | Sim |
| `ami_id` | ID da AMI para a instância. | `string` | n/a | Sim |
| `instance_type` | Tipo da instância (ex: t3.micro). | `string` | n/a | Sim |
| `subnet_id` | ID da Subnet. | `string` | n/a | Sim |
| `key_name` | Nome do Key Pair para acesso SSH. | `string` | `null` | Não |
| `vpc_security_group_ids` | Lista de IDs de Security Groups. | `list(string)` | `[]` | Não |
| `associate_public_ip_address` | Se `true`, associa um IP público. | `bool` | `false` | Não |
| `user_data` | Script de inicialização (bootstrap). | `string` | `null` | Não |
| `iam_instance_profile` | Nome do perfil de instância IAM. | `string` | `null` | Não |
| `tags` | Mapa de tags customizadas adicionais. | `map(string)` | `{}` | Não |

## Saídas (Outputs)

| Nome | Descrição |
|------|-----------|
| `id` | O ID da instância EC2. |
| `arn` | O ARN da instância. |
| `private_ip` | O endereço IP privado. |
| `public_ip` | O endereço IP público (se houver). |
| `public_dns` | O DNS público (se houver). |
