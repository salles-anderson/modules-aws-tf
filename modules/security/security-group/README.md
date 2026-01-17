# Security Group Module

Este módulo provisiona um Security Group na AWS, permitindo a definição dinâmica de regras de entrada (ingress) e saída (egress).

## Arquitetura

O módulo cria:
*   `aws_security_group`: O grupo de segurança com regras inline.

## Características

*   Flexibilidade para definir regras via lista de objetos.
*   Suporte para `cidr_blocks` ou `source_security_group_id`/`destination_security_group_id` dentro da mesma estrutura.
*   Validação de entradas (protocolo e portas).

## Uso Básico

```hcl
module "web_sg" {
  source = "../../modules/security/security-group"

  project_name = "my-project"
  name         = "web-server-sg"
  vpc_id       = "vpc-12345"

  ingress_rules = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow HTTP"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow HTTPS"
    }
  ]

  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow all outbound"
    }
  ]
}
```

## Exemplos

Consulte `examples/security-group/` para exemplos detalhados.
*   [Basic](examples/security-group/basic): Exemplo simples com regras HTTP/HTTPS.
*   [Inter-SG](examples/security-group/inter-sg): Exemplo de regras referenciando outros Security Groups.

## Entradas (Inputs)

| Nome | Descrição | Tipo | Padrão | Obrigatório |
|------|-----------|------|--------|:-----------:|
| `project_name` | Nome do projeto. | `string` | n/a | Sim |
| `name` | Nome do SG. | `string` | n/a | Sim |
| `description` | Descrição do SG. | `string` | `Managed by Terraform` | Não |
| `vpc_id` | ID da VPC. | `string` | n/a | Sim |
| `ingress_rules` | Lista de regras de entrada. | `list(object)` | `[]` | Não |
| `egress_rules` | Lista de regras de saída. | `list(object)` | `Allow All` | Não |
| `tags` | Tags adicionais. | `map(string)` | `{}` | Não |

## Saídas (Outputs)

| Nome | Descrição |
|------|-----------|
| `id` | ID do Security Group. |
| `arn` | ARN do Security Group. |
