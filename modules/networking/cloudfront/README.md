# Amazon CloudFront Module

Este módulo provisiona uma distribuição Amazon CloudFront completa, permitindo configurar origens múltiplas, comportamentos de cache (default e ordenados), certificados e integrações com WAF/Route53.

## Arquitetura

O módulo cria um único `aws_cloudfront_distribution` com suporte a:
*   Múltiplas origens (S3 ou Custom) com headers, origin shield e OAI.
*   Cache Behavior padrão obrigatório e comportamentos adicionais ordenados.
*   Alias (CNAME), certificados ACM/IAM ou certificado default.
*   Integração opcional com AWS WAF e access logs em bucket S3.

## Uso Básico

```hcl
module "cloudfront" {
  source = "../../modules/networking/cloudfront"

  project_name = "my-project"
  name         = "static-site-cdn"

  aliases = ["cdn.example.com"]

  origins = {
    s3 = {
      domain_name = "my-artifacts.s3.amazonaws.com"
      origin_id   = "s3-static"
      s3_origin_config = {
        origin_access_identity = "origin-access-identity/cloudfront/E3ABCD123"
      }
    }
  }

  default_cache_behavior = {
    target_origin_id       = "s3-static"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    query_string           = false
    forwarded_headers      = []
    cookies_forward        = "none"
  }

  ordered_cache_behaviors = [
    {
      path_pattern           = "/api/*"
      target_origin_id       = "s3-static"
      viewer_protocol_policy = "https-only"
      allowed_methods        = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
      cached_methods         = ["GET", "HEAD"]
      query_string           = true
      forwarded_headers      = ["Authorization"]
      cookies_forward        = "all"
    }
  ]

  viewer_certificate = {
    acm_certificate_arn            = "arn:aws:acm:us-east-1:123456789012:certificate/abcd-efgh"
    ssl_support_method             = "sni-only"
    cloudfront_default_certificate = false
  }

  restrictions = {
    geo_restriction = {
      restriction_type = "whitelist"
      locations        = ["BR"]
    }
  }
}
```

## Entradas (Inputs)

| Nome | Descrição | Tipo | Padrão | Obrigatório |
|------|-----------|------|--------|:-----------:|
| `project_name` | Nome do projeto usado nas tags padrão. | `string` | n/a | Sim |
| `name` | Nome lógico do módulo/ distribuição (usado em tags/comentário). | `string` | n/a | Sim |
| `comment` | Comentário exibido no console do CloudFront. | `string` | `null` | Não |
| `enabled` | Se `false`, cria a distribuição desabilitada. | `bool` | `true` | Não |
| `aliases` | Lista de domínios extras (CNAMEs). | `list(string)` | `[]` | Não |
| `default_root_object` | Objeto retornado quando não há caminho. | `string` | `null` | Não |
| `http_version` | Versão HTTP suportada. | `string` | `"http2and3"` | Não |
| `is_ipv6_enabled` | Habilita IPv6. | `bool` | `true` | Não |
| `price_class` | Classe de preço CloudFront. | `string` | `"PriceClass_All"` | Não |
| `web_acl_id` | ARN/ID do AWS WAF associado. | `string` | `null` | Não |
| `wait_for_deployment` | Aguarda distribuição ficar ativa antes de finalizar o apply. | `bool` | `true` | Não |
| `origins` | Mapa de origens (S3/custom). | `map(object)` | `{}` | Sim (necessário ao usar o módulo) |
| `default_cache_behavior` | Configuração do comportamento padrão. | `object` | n/a | Sim |
| `ordered_cache_behaviors` | Lista de comportamentos adicionais. | `list(object)` | `[]` | Não |
| `restrictions` | Configuração de restrições (geo). | `object` | `{ geo_restriction = { restriction_type = "none" } }` | Não |
| `viewer_certificate` | Configuração do certificado (ACM, IAM ou default). | `object` | `cloudfront default certificate` | Não |
| `logging_config` | Configuração opcional de Access Logs. | `object` | `null` | Não |
| `tags` | Tags adicionais. | `map(string)` | `{}` | Não |

> Observação: Ao habilitar logs (`logging_config`), o bucket deve estar no formato `bucket-name.s3.amazonaws.com`, como exigido pelo CloudFront.

## Saídas (Outputs)

| Nome | Descrição |
|------|-----------|
| `distribution_id` | ID da distribuição. |
| `distribution_arn` | ARN da distribuição. |
| `distribution_domain_name` | DNS público `*.cloudfront.net`. |
| `distribution_hosted_zone_id` | Hosted Zone ID para registros Alias no Route53. |
| `distribution_status` | Status (InProgress/Deployed). |
