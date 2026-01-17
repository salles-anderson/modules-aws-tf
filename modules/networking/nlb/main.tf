locals {
  tags = merge(
    {
      Project = var.project_name
    },
    var.tags,
  )
}

resource "aws_lb" "this" {
  name                             = var.name
  internal                         = var.internal
  load_balancer_type               = "network"
  enable_deletion_protection       = var.enable_deletion_protection
  enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing

  dynamic "subnet_mapping" {
    for_each = var.subnet_mappings
    content {
      subnet_id     = subnet_mapping.value.subnet_id
      allocation_id = try(subnet_mapping.value.allocation_id, null)
    }
  }

  tags = merge(
    local.tags,
    {
      Name = var.name
    },
  )
}

resource "aws_lb_target_group" "this" {
  for_each = var.target_groups

  name        = "${var.name}-${each.key}"
  port        = each.value.port
  protocol    = each.value.protocol
  target_type = lookup(each.value, "target_type", "ip")
  vpc_id      = var.vpc_id

  health_check {
    enabled             = lookup(each.value.health_check, "enabled", true)
    interval            = lookup(each.value.health_check, "interval", 30)
    healthy_threshold   = lookup(each.value.health_check, "healthy_threshold", 3)
    unhealthy_threshold = lookup(each.value.health_check, "unhealthy_threshold", 3)
    timeout             = lookup(each.value.health_check, "timeout", 5)
    protocol            = lookup(each.value.health_check, "protocol", "TCP")
    port                = lookup(each.value.health_check, "port", "traffic-port")
    matcher             = lookup(each.value.health_check, "matcher", null)
  }

  tags = merge(
    local.tags,
    {
      Name = "${var.name}-${each.key}"
    },
  )
}

resource "aws_lb_listener" "this" {
  for_each = var.listeners

  load_balancer_arn = aws_lb.this.arn
  port              = each.value.port
  protocol          = each.value.protocol
  certificate_arn   = lookup(each.value, "certificate_arn", null)
  ssl_policy        = lookup(each.value, "ssl_policy", null)
  # Alguns providers esperam string (não lista); normalizamos pegando o primeiro item ou usando o valor bruto
  alpn_policy = try(each.value.alpn_policy[0], try(each.value.alpn_policy, null))

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this[each.value.target_group_key].arn
  }
}
