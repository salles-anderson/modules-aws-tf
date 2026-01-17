# =============================================================================
# Kong Gateway Module - Security Groups
# =============================================================================

# Security Group do Kong
resource "aws_security_group" "kong" {
  name        = "${var.name_prefix}-kong-sg"
  description = "Security group for Kong API Gateway"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-kong-sg"
  })

  lifecycle {
    create_before_destroy = true
  }
}

# Ingress: ALB -> Kong (proxy port)
resource "aws_security_group_rule" "kong_from_alb" {
  type                     = "ingress"
  from_port                = var.kong_proxy_port
  to_port                  = var.kong_proxy_port
  protocol                 = "tcp"
  security_group_id        = aws_security_group.kong.id
  source_security_group_id = var.alb_security_group_id
  description              = "Allow traffic from ALB to Kong proxy"
}

# Ingress: Backend -> Kong Admin API (para health checks internos)
resource "aws_security_group_rule" "kong_admin_from_backend" {
  type                     = "ingress"
  from_port                = var.kong_admin_port
  to_port                  = var.kong_admin_port
  protocol                 = "tcp"
  security_group_id        = aws_security_group.kong.id
  source_security_group_id = var.backend_security_group_id
  description              = "Allow admin API access from backend (internal)"
}

# Egress: Kong -> Backend API
resource "aws_security_group_rule" "kong_to_backend" {
  type                     = "egress"
  from_port                = var.backend_port
  to_port                  = var.backend_port
  protocol                 = "tcp"
  security_group_id        = aws_security_group.kong.id
  source_security_group_id = var.backend_security_group_id
  description              = "Allow Kong to reach backend API"
}

# Egress: Kong -> Internet (HTTPS - para plugins, ALB externo, etc)
resource "aws_security_group_rule" "kong_to_https" {
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.kong.id
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow Kong to reach external HTTPS endpoints"
}

# Egress: Kong -> HTTP (para backend via ALB interno)
resource "aws_security_group_rule" "kong_to_http" {
  type              = "egress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.kong.id
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow Kong to reach HTTP endpoints (internal ALB)"
}

# Egress: Kong -> Redis (se habilitado)
resource "aws_security_group_rule" "kong_to_redis" {
  count                    = var.enable_redis && var.redis_security_group_id != null ? 1 : 0
  type                     = "egress"
  from_port                = var.redis_port
  to_port                  = var.redis_port
  protocol                 = "tcp"
  security_group_id        = aws_security_group.kong.id
  source_security_group_id = var.redis_security_group_id
  description              = "Allow Kong to reach Redis for rate limiting"
}

# =============================================================================
# Regras adicionais no Security Group do Backend
# =============================================================================

# Permitir Kong -> Backend API
resource "aws_security_group_rule" "backend_from_kong" {
  type                     = "ingress"
  from_port                = var.backend_port
  to_port                  = var.backend_port
  protocol                 = "tcp"
  security_group_id        = var.backend_security_group_id
  source_security_group_id = aws_security_group.kong.id
  description              = "Allow traffic from Kong to backend API"
}

# =============================================================================
# Regras adicionais no Security Group do Redis (se habilitado)
# =============================================================================

resource "aws_security_group_rule" "redis_from_kong" {
  count                    = var.enable_redis && var.redis_security_group_id != null ? 1 : 0
  type                     = "ingress"
  from_port                = var.redis_port
  to_port                  = var.redis_port
  protocol                 = "tcp"
  security_group_id        = var.redis_security_group_id
  source_security_group_id = aws_security_group.kong.id
  description              = "Allow Redis from Kong (rate limiting)"
}
