module "acm_wildcard" {
  source = "../../../modules/security/acm"

  domain_name               = "*.example.com"
  subject_alternative_names = ["example.com"]
  hosted_zone_id            = "Z0123456789ABCDEF" # Dummy Zone ID
}

output "cert_arn" {
  value = module.acm_wildcard.arn
}
