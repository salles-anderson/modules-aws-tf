module "acm_basic" {
  source = "../../../modules/security/acm"

  domain_name    = "test.example.com"
  hosted_zone_id = "Z0123456789ABCDEF" # Dummy Zone ID
}

output "cert_arn" {
  value = module.acm_basic.arn
}
