module "alb_https" {
  source = "../../../modules/networking/alb"

  project_name       = "alb-https-demo"
  name               = "alb-https"
  vpc_id             = "vpc-0123456789abcdef0"                                  # Dummy VPC
  subnet_ids         = ["subnet-0123456789abcdef0", "subnet-0123456789abcdef1"] # Dummy Subnets
  security_group_ids = ["sg-0123456789abcdef0"]                                 # Dummy SG

  target_groups = {
    secure = {
      port              = 443
      protocol          = "HTTPS"
      target_type       = "ip"
      health_check_path = "/health"
    }
  }

  listeners = {
    https = {
      port             = 443
      protocol         = "HTTPS"
      action_type      = "forward"
      target_group_key = "secure"
      certificate_arn  = "arn:aws:acm:us-east-1:123456789012:certificate/12345678-1234-1234-1234-123456789012" # Dummy Cert
    }
  }
}

output "dns_name" {
  value = module.alb_https.lb_dns_name
}
