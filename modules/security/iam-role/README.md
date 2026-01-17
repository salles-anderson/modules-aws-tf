# IAM Role Module

Este módulo é um wrapper genérico para criar uma IAM Role e anexar múltiplas políticas a ela.

## Arquitetura

O módulo cria:
*   `aws_iam_role`: A role com a política de confiança fornecida.
*   `aws_iam_role_policy_attachment`: Anexa as políticas especificadas via ARN à role.

## Uso Básico

```hcl
module "my_role" {
  source = "../../modules/security/iam-role"

  role_name = "my-service-role"

  assume_role_policy_json = jsonencode({
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

  policy_arns = [
    "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]
}
```

## Exemplos

Consulte `examples/iam-role/` para exemplos detalhados.
*   [Basic](examples/iam-role/basic): Exemplo simples de role para EC2.

## Entradas (Inputs)

| Nome | Descrição | Tipo | Padrão | Obrigatório |
|------|-----------|------|--------|:-----------:|
| `role_name` | Nome da role. | `string` | n/a | Sim |
| `assume_role_policy_json` | JSON da Trust Policy. | `string` | n/a | Sim |
| `policy_arns` | Lista de ARNs de políticas. | `list(string)` | `[]` | Não |
| `path` | Caminho IAM. | `string` | `/` | Não |
| `description` | Descrição da role. | `string` | `null` | Não |
| `tags` | Tags adicionais. | `map(string)` | `{}` | Não |

## Saídas (Outputs)

| Nome | Descrição |
|------|-----------|
| `role_arn` | ARN da role. |
| `role_name` | Nome da role. |
| `role_id` | ID único da role. |
