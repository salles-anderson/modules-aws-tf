module "alb_http" {
  source = "../../../modules/networking/alb"

  project_name       = "alb-http-demo"
  name               = "alb-http"
  vpc_id             = "vpc-0123456789abcdef0"                                  # Dummy VPC
  subnet_ids         = ["subnet-0123456789abcdef0", "subnet-0123456789abcdef1"] # Dummy Subnets
  security_group_ids = ["sg-0123456789abcdef0"]                                 # Dummy SG

  target_groups = {
    main = {
      port              = 80
      protocol          = "HTTP"
      target_type       = "instance"
      health_check_path = "/"
    }
  }

  listeners = {
    http = {
      port             = 80
      protocol         = "HTTP"
      action_type      = "forward"
      target_group_key = "main"
    }
  }
}

output "dns_name" {
  value = module.alb_http.lb_dns_name
}
