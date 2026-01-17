# EC2 RKE2 Node Module

Este módulo provisiona instâncias EC2 otimizadas e configuradas para formar nós de um cluster Kubernetes RKE2 (Rancher Kubernetes Engine 2).

## Arquitetura

O módulo cria um ou mais recursos `aws_instance` e utiliza um script de `user_data` para instalar e configurar o RKE2.

## Funcionalidades

*   Suporte a nós do tipo `server` (control-plane) e `agent` (worker).
*   Configuração automática do RKE2 via script de inicialização.
*   Distribuição automática de instâncias entre múltiplas subnets para alta disponibilidade.
*   Configuração de armazenamento criptografado (EBS) e IMDSv2.

## Uso Básico

```hcl
module "rke2_server" {
  source = "../../modules/compute/ec2-rke2-node"

  project_name              = "my-k8s"
  cluster_name              = "prod-cluster"
  rke2_role                 = "server"
  rke2_version              = "v1.28.5+rke2r1"
  rke2_token                = "my-secure-token"
  instance_type             = "t3.medium"
  instance_count            = 3
  subnet_ids                = ["subnet-1", "subnet-2", "subnet-3"]
  security_group_ids        = ["sg-12345"]
  iam_instance_profile_name = "k8s-node-role"
}
```

## Exemplos

Consulte o diretório `examples/ec2-rke2-node/` para exemplos:

*   [Server](examples/ec2-rke2-node/server): Exemplo de criação de nós control-plane.
*   [Agent](examples/ec2-rke2-node/agent): Exemplo de criação de nós workers.

## Entradas (Inputs)

| Nome | Descrição | Tipo | Padrão | Obrigatório |
|------|-----------|------|--------|:-----------:|
| `project_name` | Nome do projeto. | `string` | n/a | Sim |
| `cluster_name` | Nome do cluster K8s. | `string` | n/a | Sim |
| `instance_count` | Número de nós. | `number` | `1` | Não |
| `ami_id` | ID da AMI (opcional, busca Ubuntu 22.04 se nulo). | `string` | `null` | Não |
| `instance_type` | Tipo da instância. | `string` | n/a | Sim |
| `subnet_ids` | Lista de Subnets para distribuir os nós. | `list(string)` | n/a | Sim |
| `security_group_ids` | Lista de Security Groups. | `list(string)` | n/a | Sim |
| `iam_instance_profile_name` | Nome do IAM Instance Profile. | `string` | n/a | Sim |
| `key_name` | Nome do Key Pair SSH. | `string` | `null` | Não |
| `root_volume_size` | Tamanho do disco raiz (GB). | `number` | `50` | Não |
| `rke2_version` | Versão do RKE2. | `string` | n/a | Sim |
| `rke2_role` | Papel do nó (`server` ou `agent`). | `string` | n/a | Sim |
| `rke2_token` | Token de junção do cluster. | `string` | n/a | Sim |
| `tags` | Tags adicionais. | `map(string)` | `{}` | Não |

## Saídas (Outputs)

| Nome | Descrição |
|------|-----------|
| `instance_ids` | Lista de IDs das instâncias criadas. |
| `private_ips` | Lista de IPs privados das instâncias. |
| `ami_used` | A AMI utilizada. |
