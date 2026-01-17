locals {
  tags = merge(
    {
      "Project" = var.project_name
    },
    var.tags,
  )
}

resource "aws_lb" "this" {
  name               = var.name
  internal           = var.internal
  load_balancer_type = "application"
  security_groups    = var.security_group_ids
  subnets            = var.subnet_ids

  enable_deletion_protection = false # Para ambientes de dev/teste. Em produção, considere `true`.

  dynamic "access_logs" {
    for_each = var.access_logs.enabled ? [1] : []

    content {
      bucket  = var.access_logs.bucket
      prefix  = var.access_logs.prefix
      enabled = true
    }
  }

  tags = merge(
    local.tags,
    {
      "Name" = var.name
    }
  )
}

resource "aws_lb_target_group" "this" {
  for_each = var.target_groups

  name        = "${var.name}-${each.key}"
  port        = each.value.port
  protocol    = each.value.protocol
  vpc_id      = var.vpc_id
  target_type = each.value.target_type

  health_check {
    enabled             = lookup(each.value, "health_check_enabled", true)
    path                = lookup(each.value, "health_check_path", "/")
    port                = lookup(each.value, "health_check_port", "traffic-port")
    protocol            = lookup(each.value, "health_check_protocol", "HTTP")
    matcher             = lookup(each.value, "health_check_matcher", "200")
    interval            = lookup(each.value, "health_check_interval", 30)
    timeout             = lookup(each.value, "health_check_timeout", 5)
    healthy_threshold   = lookup(each.value, "health_check_healthy_threshold", 3)
    unhealthy_threshold = lookup(each.value, "health_check_unhealthy_threshold", 3)
  }

  tags = merge(
    local.tags,
    {
      "Name" = "${var.name}-${each.key}"
    }
  )
}

resource "aws_lb_listener" "this" {
  for_each = var.listeners

  load_balancer_arn = aws_lb.this.arn
  port              = each.value.port
  protocol          = each.value.protocol
  ssl_policy        = lookup(each.value, "ssl_policy", null)
  certificate_arn   = lookup(each.value, "certificate_arn", null)

  default_action {
    type             = each.value.action_type
    target_group_arn = aws_lb_target_group.this[each.value.target_group_key].arn
  }
}