# Checklist de Validação para os Módulos ACM e Route53

Este checklist foi projetado para ajudá-lo a validar as melhorias nos módulos `acm` e `route53` usando o exemplo de integração fornecido.

## Pré-requisitos

1.  [ ] **Credenciais da AWS:** Certifique-se de que suas credenciais da AWS estejam configuradas corretamente no seu ambiente (ex: via variáveis de ambiente `AWS_ACCESS_KEY_ID` e `AWS_SECRET_ACCESS_KEY`, ou um perfil AWS).
2.  [ ] **Terraform Instalado:** Verifique se você tem o Terraform CLI instalado (versão 1.0 ou superior).
3.  [ ] **Hosted Zone Existente:** Você deve ter uma Hosted Zone pública no Route53 para o domínio que deseja usar nos testes.

## Passos de Validação

Siga estes passos dentro do diretório `examples/acm-route53/` do repositório.

1.  [ ] **Navegue até o Diretório de Exemplo:**
    ```bash
    cd examples/acm-route53/
    ```

2.  [ ] **Configure suas Variáveis:**
    -   Abra o arquivo `variables.tf` (ou, preferencialmente, crie um arquivo `terraform.tfvars`).
    -   Altere o valor padrão da variável `root_domain_name` para o nome da sua Hosted Zone.

    **Exemplo de `terraform.tfvars`:**
    ```hcl
    root_domain_name = "seu-dominio-real.com"
    aws_region       = "us-east-1" // Ou sua região de preferência
    ```

3.  [ ] **Inicialize o Terraform:**
    -   Execute o comando `terraform init`.
    -   **Resultado Esperado:** O Terraform deve baixar os provedores necessários (AWS) sem erros.

4.  [ ] **Valide a Configuração:**
    -   Execute o comando `terraform validate`.
    -   **Resultado Esperado:** O Terraform deve retornar uma mensagem de sucesso, indicando que a sintaxe e a configuração estão corretas.

5.  [ ] **Planeje a Infraestrutura:**
    -   Execute o comando `terraform plan`.
    -   **Resultado Esperado:** O Terraform deve mostrar um plano para criar os seguintes recursos:
        -   `module.certificate.aws_acm_certificate.this`
        -   `module.certificate.aws_route53_record.validation[...]`
        -   `module.certificate.aws_acm_certificate_validation.this`
        -   `module.dns_record.aws_route53_record.this["api"]`
    -   Verifique se os nomes de domínio e os detalhes dos registros parecem corretos.

6.  [ ] **Aplique as Mudanças:**
    -   Execute o comando `terraform apply` e confirme com `yes`.
    -   **Aguarde a Conclusão:** A validação do certificado ACM pode levar alguns minutos. O Terraform gerenciará essa espera.
    -   **Resultado Esperado:** O `apply` deve ser concluído com sucesso, e os outputs (`certificate_arn` e `api_endpoint_fqdn`) devem ser exibidos.

7.  [ ] **Verifique os Recursos na AWS Console:**
    -   **AWS Certificate Manager (ACM):**
        -   [ ] Navegue até o console do ACM na região especificada.
        -   [ ] Localize o certificado para `api.seu-dominio-real.com`.
        -   [ ] Verifique se o status do certificado é **"Issued" (Emitido)**.
    -   **AWS Route53:**
        -   [ ] Navegue até o console do Route53.
        -   [ ] Acesse sua Hosted Zone.
        -   [ ] Verifique se o registro de validação do ACM (um CNAME com um nome longo e aleatório) foi criado e, em seguida, se o registro `api.seu-dominio-real.com` (tipo A/ALIAS) foi criado corretamente, apontando para o destino fictício do ALB.

8.  [ ] **Destrua os Recursos:**
    -   Após a validação, execute `terraform destroy` e confirme com `yes` para remover os recursos criados e evitar custos.
    -   **Resultado Esperado:** Todos os recursos criados pelo Terraform devem ser removidos com sucesso.

Se todos os passos acima foram concluídos com sucesso, as melhorias nos módulos e a estratégia de integração estão validadas!
