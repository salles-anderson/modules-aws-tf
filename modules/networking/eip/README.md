# Elastic IP (EIP) Module

Este módulo provisiona um Elastic IP (EIP) na AWS e, opcionalmente, o associa a uma instância EC2.

## Arquitetura

O módulo cria:
*   `aws_eip`: O endereço IP estático.
*   `aws_eip_association` (opcional): Associa o IP a uma instância.

## Uso Básico

```hcl
module "eip" {
  source = "../../modules/networking/eip"

  project_name = "my-project"
  name         = "my-eip"
  instance_id  = "i-1234567890abcdef0"
}
```

## Exemplos

Consulte `examples/eip/` para exemplos detalhados.
*   [Basic](examples/eip/basic): Alocação simples de EIP.
*   [Associated](examples/eip/associated): Alocação e associação a uma instância.

## Entradas (Inputs)

| Nome | Descrição | Tipo | Padrão | Obrigatório |
|------|-----------|------|--------|:-----------:|
| `project_name` | Nome do projeto. | `string` | n/a | Sim |
| `name` | Nome do EIP. | `string` | n/a | Sim |
| `instance_id` | ID da instância para associação. | `string` | `null` | Não |
| `tags` | Tags adicionais. | `map(string)` | `{}` | Não |

## Saídas (Outputs)

| Nome | Descrição |
|------|-----------|
| `public_ip` | Endereço IP público. |
| `allocation_id` | ID de alocação. |
| `private_ip` | Endereço IP privado associado. |
| `association_id` | ID da associação. |
