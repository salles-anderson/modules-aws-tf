module "route53_alias" {
  source = "../../../modules/networking/route53"

  zone_id = "Z0123456789ABCDEF" # Dummy Zone ID

  records = {
    app_alias = {
      name = "app"
      type = "A"
      alias = {
        name                   = "dualstack.my-loadbalancer-1234567890.us-east-1.elb.amazonaws.com"
        zone_id                = "Z35SXDOTRQ7X7K"
        evaluate_target_health = false
      }
    }
  }
}

output "fqdns" {
  value = module.route53_alias.record_fqdns
}
