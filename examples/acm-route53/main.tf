# Provedor e Configurações da AWS
provider "aws" {
  region = var.aws_region
}

# --- Dados Fictícios ---
# Em um cenário real, estes dados viriam de outros módulos (ex: um módulo ALB).
locals {
  alb_dns_name = "my-alb-1234567890.us-east-1.elb.amazonaws.com"
  alb_zone_id  = "Z35SXDOTRQ7X7K" # Exemplo de Zone ID para ALBs em us-east-1
  domain_name  = "api.${var.root_domain_name}"
}

# --- Busca de Dados ---
# É uma boa prática buscar a Hosted Zone em vez de passar seu ID diretamente.
data "aws_route53_zone" "this" {
  name         = var.root_domain_name
  private_zone = false
}

# --- Módulo ACM: Criação do Certificado ---
# Primeiro, criamos o certificado e seus registros de validação.
module "certificate" {
  source = "../../modules/security/acm"

  domain_name    = local.domain_name
  hosted_zone_id = data.aws_route53_zone.this.zone_id

  tags = {
    Environment = "example"
    ManagedBy   = "Terraform"
    Project     = "ACM+Route53 Integration"
  }
}

# --- Módulo Route53: Criação do Registro Principal ---
# Após a validação do certificado (gerenciada pelo módulo ACM),
# criamos o registro principal para o subdomínio.
module "dns_record" {
  source = "../../modules/networking/route53"

  zone_id = data.aws_route53_zone.this.zone_id

  records = {
    "api" = {
      name = "api"
      type = "A"
      alias = {
        name                   = local.alb_dns_name
        zone_id                = local.alb_zone_id
        evaluate_target_health = true
      }
    }
  }

  # Depende explicitamente da conclusão da validação do certificado.
  # Isso garante que o registro principal só seja criado após o certificado estar pronto.
  depends_on = [
    module.certificate
  ]
}
