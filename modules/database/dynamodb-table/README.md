# DynamoDB Table Module

Este módulo provisiona uma tabela DynamoDB na AWS.

## Arquitetura

O módulo cria um recurso `aws_dynamodb_table`.

## Características

*   Suporte flexível a atributos via lista de objetos.
*   Configuração de `billing_mode` (padrão `PAY_PER_REQUEST`).
*   Configuração simples de Hash Key e Range Key (opcional).

## Uso Básico

```hcl
module "my_table" {
  source = "../../modules/database/dynamodb-table"

  project_name = "my-project"
  table_name   = "Users"
  hash_key     = "UserId"

  attributes = [
    { name = "UserId", type = "S" }
  ]
}
```

## Exemplos

Consulte `examples/dynamodb-table/` para exemplos detalhados.
*   [Basic](examples/dynamodb-table/basic): Tabela simples com apenas Hash Key.
*   [Range Key](examples/dynamodb-table/range-key): Tabela com Hash e Range Key.

## Entradas (Inputs)

| Nome | Descrição | Tipo | Padrão | Obrigatório |
|------|-----------|------|--------|:-----------:|
| `project_name` | Nome do projeto. | `string` | n/a | Sim |
| `table_name` | Nome da tabela. | `string` | n/a | Sim |
| `billing_mode` | Modo de cobrança (`PROVISIONED` ou `PAY_PER_REQUEST`). | `string` | `PAY_PER_REQUEST` | Não |
| `hash_key` | Atributo da chave de partição. | `string` | n/a | Sim |
| `range_key` | Atributo da chave de ordenação (opcional). | `string` | `null` | Não |
| `attributes` | Lista de atributos (nome e tipo). | `list(object)` | `[]` | Não |
| `tags` | Tags adicionais. | `map(string)` | `{}` | Não |

## Saídas (Outputs)

| Nome | Descrição |
|------|-----------|
| `table_arn` | ARN da tabela criada. |
| `table_id` | ID da tabela criada. |
