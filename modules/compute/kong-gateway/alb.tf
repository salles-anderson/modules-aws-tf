# =============================================================================
# Kong Gateway Module - ALB Integration
# =============================================================================

# Target Group para Kong
resource "aws_lb_target_group" "kong" {
  name        = "${var.name_prefix}-kong-tg"
  port        = var.kong_proxy_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    enabled             = true
    path                = var.health_check_path
    protocol            = "HTTP"
    port                = "traffic-port"
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    matcher             = "200"
  }

  deregistration_delay = 30

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-kong-tg"
  })

  lifecycle {
    create_before_destroy = true
  }
}

# Listener Rule - Rotear paths configurados para Kong
resource "aws_lb_listener_rule" "kong" {
  listener_arn = var.listener_arn
  priority     = var.listener_rule_priority

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.kong.arn
  }

  condition {
    path_pattern {
      values = var.routing_paths
    }
  }

  tags = var.tags
}
