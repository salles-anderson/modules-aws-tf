# Exemplo de Infraestrutura Completa: SSM Bastion

Este diretório contém um exemplo completo de como implantar uma instância bastion segura na AWS usando Terraform. A solução utiliza o **AWS Systems Manager (SSM) Session Manager** para acesso, eliminando a necessidade de chaves SSH, IPs públicos e portas de segurança abertas, seguindo as melhores práticas de segurança.

## Arquitetura

A infraestrutura criada por este exemplo consiste em:

1.  **VPC (Virtual Private Cloud):** Uma nova VPC é criada com um CIDR de `10.0.0.0/16`.
2.  **Sub-redes Públicas e Privadas:**
    - **2 Sub-redes Públicas:** Utilizadas para recursos que precisam de acesso direto à internet, como o NAT Gateway.
    - **2 Sub-redes Privadas:** Onde a instância do bastion é alocada. Recursos nestas sub-redes não são acessíveis diretamente da internet.
3.  **Internet Gateway:** Permite a comunicação entre a VPC e a internet.
4.  **NAT Gateway:** Alocado em uma das sub-redes públicas, permite que a instância bastion (na sub-rede privada) inicie conexões com a internet (necessário para o agente SSM se comunicar com a AWS), mas não permite conexões de entrada da internet.
5.  **Instância EC2 (Bastion):**
    - Uma instância `t3.micro` rodando Amazon Linux 2.
    - Localizada em uma sub-rede privada, sem IP público associado.
    - Possui uma IAM Role com a política `AmazonSSMManagedInstanceCore`, que concede as permissões mínimas para o SSM funcionar.
    - O Security Group associado não possui **nenhuma regra de entrada (ingress)** e permite todo o tráfego de saída (egress).

Este design garante que o bastion esteja altamente protegido contra ataques externos, pois não há um ponto de entrada direto da internet.

## Pré-requisitos

Antes de começar, garanta que você tenha:

1.  **Conta na AWS:** Com as devidas permissões para criar os recursos descritos acima.
2.  **AWS CLI:** [Instalado e configurado](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html) com suas credenciais.
3.  **Terraform:** [Instalado](https://learn.hashicorp.com/tutorials/terraform/install-cli) (versão 1.0 ou superior).
4.  **Plugin Session Manager para AWS CLI:** [Instalado](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html). Este plugin é necessário para que o comando `aws ssm start-session` funcione.

## Como Usar

### 1. Inicializar o Terraform

Navegue até este diretório (`examples/ssm-bastion-complete`) e execute o comando `init`. Isso fará o download do provedor AWS e inicializará os módulos.

```bash
terraform init
```

### 2. Planejar a Implantação

Execute `plan` para ver todos os recursos que o Terraform irá criar. É uma boa prática revisar o plano antes de aplicar.

```bash
terraform plan
```

### 3. Aplicar a Configuração

Aplique a configuração para criar a infraestrutura na sua conta AWS. O Terraform pedirá uma confirmação final.

```bash
terraform apply
```

Após a conclusão, o Terraform exibirá as saídas (outputs), incluindo o comando para se conectar ao bastion.

### 4. Conectar ao Bastion

Use o comando de saída `connect_command` para iniciar uma sessão segura no seu bastion.

```bash
aws ssm start-session --target <ID-DA-INSTANCIA> --region <SUA-REGIAO>
```
*Substitua `<ID-DA-INSTANCIA>` e `<SUA-REGIAO>` pelos valores corretos, ou simplesmente copie o comando da saída do Terraform.*

Uma vez conectado, você terá um shell de comando na sua instância bastion, de onde poderá acessar outros recursos na sua VPC privada.

### 5. Destruir a Infraestrutura

Quando não precisar mais do bastion, você pode destruir todos os recursos criados com um único comando. Isso evita custos desnecessários.

```bash
terraform destroy
```
