# SSM Bastion Module

Este módulo provisiona uma instância EC2 "Bastion" segura, configurada para ser acessada exclusivamente via AWS Systems Manager (SSM) Session Manager.

## Arquitetura

O módulo cria:
*   `aws_instance`: A instância EC2 (padrão: Amazon Linux 2).
*   `aws_iam_role`: Role com a política `AmazonSSMManagedInstanceCore` anexada.
*   `aws_security_group`: Grupo de segurança que permite apenas saída (egress), sem necessidade de abrir portas de entrada (ingress) como SSH (22).

## Características

*   **Segurança Aprimorada:** Elimina a necessidade de chaves SSH e portas abertas na internet.
*   **Auditoria:** Todas as sessões são logadas pelo AWS SSM.
*   **Custo Efetivo:** Pode ser implantada em sub-redes privadas (requer VPC Endpoints ou NAT Gateway).

## Uso Básico

```hcl
module "bastion" {
  source = "../../modules/security/ssm-bastion"

  project_name = "my-project"
  vpc_id       = "vpc-12345"
  subnet_id    = "subnet-private-1"
}
```

## Acessando a Instância

Após o provisionamento, você pode se conectar à instância usando a AWS CLI (requer plugin do Session Manager):

```bash
aws ssm start-session --target <INSTANCE_ID>
```

## Exemplos

Consulte `examples/ssm-bastion/` para exemplos detalhados.
*   [Basic](examples/ssm-bastion/basic): Bastion simples em uma subnet.

## Entradas (Inputs)

| Nome | Descrição | Tipo | Padrão | Obrigatório |
|------|-----------|------|--------|:-----------:|
| `project_name` | Nome do projeto. | `string` | n/a | Sim |
| `vpc_id` | ID da VPC. | `string` | n/a | Sim |
| `subnet_id` | ID da Subnet. | `string` | n/a | Sim |
| `name` | Nome da instância. | `string` | `ssm-bastion` | Não |
| `instance_type` | Tipo da instância. | `string` | `t3.nano` | Não |
| `ami_id` | AMI Customizada. | `string` | `null` | Não |
| `tags` | Tags adicionais. | `map(string)` | `{}` | Não |

## Saídas (Outputs)

| Nome | Descrição |
|------|-----------|
| `instance_id` | ID da instância. |
| `security_group_id` | ID do Security Group. |
| `iam_role_arn` | ARN da IAM Role. |
