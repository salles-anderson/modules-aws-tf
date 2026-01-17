# CloudFront Distribution Module

Cria uma distribuição CloudFront com suporte a origem S3 (com OAI), certificados ACM, WAF e logging opcional.

## Uso Básico

```hcl
module "cdn" {
  source = "../../modules/networking/cloudfront-distribution"

  project_name          = "plataforma-assinatura"
  distribution_comment  = "frontend-cdn"
  origin_domain_name    = "meu-bucket.s3.amazonaws.com"
  origin_id             = "s3-frontend"
  aliases               = ["app.example.com"]
  acm_certificate_arn   = "arn:aws:acm:us-east-1:123:certificate/abc"
}
```

## Inputs

| Nome | Descrição | Tipo | Padrão | Obrigatório |
|------|-----------|------|--------|:-----------:|
| `project_name` | Nome do projeto para taguear recursos. | `string` | n/a | Sim |
| `distribution_comment` | Comentário/nome amigável da distribuição. | `string` | n/a | Sim |
| `enabled` | Habilita a distribuição. | `bool` | `true` | Não |
| `price_class` | Price class (`PriceClass_100`, `PriceClass_200`, `PriceClass_All`). | `string` | `"PriceClass_100"` | Não |
| `aliases` | CNAMEs adicionais. | `list(string)` | `[]` | Não |
| `default_root_object` | Objeto padrão. | `string` | `"index.html"` | Não |
| `is_ipv6_enabled` | Habilita IPv6. | `bool` | `true` | Não |
| `origin_domain_name` | Domínio da origem. | `string` | n/a | Sim |
| `origin_id` | ID da origem. | `string` | n/a | Sim |
| `origin_path` | Prefixo opcional na origem. | `string` | `""` | Não |
| `origin_is_s3` | Define se a origem é S3. | `bool` | `true` | Não |
| `create_origin_access_identity` | Cria OAI para S3. | `bool` | `true` | Não |
| `origin_access_identity` | OAI existente (quando não cria). | `string` | `null` | Não |
| `oai_comment` | Comentário da OAI. | `string` | `"Managed by Terraform"` | Não |
| `custom_origin_http_port` | Porta HTTP da origem custom. | `number` | `80` | Não |
| `custom_origin_https_port` | Porta HTTPS da origem custom. | `number` | `443` | Não |
| `origin_protocol_policy` | Política de protocolo para origem custom. | `string` | `"https-only"` | Não |
| `origin_ssl_protocols` | Protocolos SSL permitidos na origem custom. | `list(string)` | `["TLSv1.2"]` | Não |
| `allowed_methods` | Métodos permitidos. | `list(string)` | `["GET", "HEAD", "OPTIONS"]` | Não |
| `cached_methods` | Métodos em cache. | `list(string)` | `["GET", "HEAD"]` | Não |
| `viewer_protocol_policy` | Política de protocolo do viewer. | `string` | `"redirect-to-https"` | Não |
| `cache_policy_id` | ID da cache policy. | `string` | `null` | Não |
| `origin_request_policy_id` | ID da origin request policy. | `string` | `null` | Não |
| `lambda_function_associations` | Associações de Lambda@Edge. | `list(object)` | `[]` | Não |
| `logging_bucket` | Bucket para logs (formato `<bucket>.s3.amazonaws.com`). | `string` | `null` | Não |
| `logging_include_cookies` | Inclui cookies nos logs. | `bool` | `false` | Não |
| `logging_prefix` | Prefixo para logs. | `string` | `null` | Não |
| `acm_certificate_arn` | ARN do certificado ACM (us-east-1). | `string` | `null` | Não |
| `web_acl_id` | ARN do Web ACL do WAF. | `string` | `null` | Não |
| `tags` | Mapa de tags adicionais. | `map(string)` | `{}` | Não |

## Outputs

| Nome | Descrição |
|------|-----------|
| `distribution_id` | ID da distribuição. |
| `distribution_arn` | ARN da distribuição. |
| `distribution_domain_name` | Domínio público da distribuição. |
