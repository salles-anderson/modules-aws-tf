module "route53_simple" {
  source = "../../../modules/networking/route53"

  zone_id = "Z0123456789ABCDEF" # Dummy Zone ID

  records = {
    test_a = {
      name   = "test-a"
      type   = "A"
      ttl    = 300
      values = ["1.2.3.4"]
    }
    test_cname = {
      name   = "test-cname"
      type   = "CNAME"
      ttl    = 60
      values = ["example.com"]
    }
  }
}

output "fqdns" {
  value = module.route53_simple.record_fqdns
}
