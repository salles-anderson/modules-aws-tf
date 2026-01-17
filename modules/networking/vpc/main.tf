# Touched to include in patch
data "aws_region" "current" {}

locals {

  tags = merge(
    {
      "Project" = var.project_name
    },
    var.tags,
  )
  # Decide qual ID de VPC usar: o recém-criado ou um existente.
  vpc_id = var.create_vpc ? aws_vpc.this[0].id : var.vpc_id_existing

  # Decide qual CIDR de VPC usar.
  vpc_cidr_block = var.create_vpc ? aws_vpc.this[0].cidr_block : data.aws_vpc.existing[0].cidr_block
}

# --- VPC ---
data "aws_vpc" "existing" {
  count = !var.create_vpc ? 1 : 0
  id    = var.vpc_id_existing
}

resource "aws_vpc" "this" {
  count = var.create_vpc ? 1 : 0

  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge(
    local.tags,
    {
      "Name" = "${var.project_name}-vpc"
    },
  )
}

# --- Sub-redes ---
resource "aws_subnet" "public" {
  count = var.create_vpc ? length(var.public_subnets) : 0

  vpc_id                  = local.vpc_id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true
  tags = merge(
    local.tags,
    {
      "Name" = "${var.project_name}-public-subnet-${count.index + 1}"
    },
  )
}

resource "aws_subnet" "private" {
  count = var.create_vpc ? length(var.private_subnets) : 0

  vpc_id            = local.vpc_id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = var.azs[count.index]
  tags = merge(
    local.tags,
    {
      "Name" = "${var.project_name}-private-subnet-${count.index + 1}"
    },
  )
}

data "aws_subnets" "public_existing" {
  count = !var.create_vpc && length(keys(var.public_subnet_tags_existing)) > 0 ? 1 : 0

  filter {
    name   = "vpc-id"
    values = [local.vpc_id]
  }

  tags = var.public_subnet_tags_existing
}

data "aws_subnets" "private_existing" {
  count = !var.create_vpc && length(keys(var.private_subnet_tags_existing)) > 0 ? 1 : 0

  filter {
    name   = "vpc-id"
    values = [local.vpc_id]
  }

  tags = var.private_subnet_tags_existing
}

# --- Gateway e Rotas ---
resource "aws_internet_gateway" "this" {
  count = var.create_vpc ? 1 : 0

  vpc_id = local.vpc_id
  tags = merge(
    local.tags,
    {
      "Name" = "${var.project_name}-igw"
    },
  )
}

resource "aws_route_table" "public" {
  count = var.create_vpc ? 1 : 0

  vpc_id = local.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this[0].id
  }
  tags = merge(
    local.tags,
    {
      "Name" = "${var.project_name}-public-rt"
    },
  )
}

resource "aws_route_table_association" "public" {
  count = var.create_vpc ? length(var.public_subnets) : 0

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public[0].id
}

# --- NAT Gateway ---
resource "aws_eip" "nat" {
  count = var.create_vpc && var.enable_nat_gateway ? 1 : 0

  domain = "vpc"
  tags = merge(
    local.tags,
    {
      "Name" = "${var.project_name}-nat-eip"
    },
  )
}

resource "aws_nat_gateway" "nat" {
  count = var.create_vpc && var.enable_nat_gateway ? 1 : 0

  allocation_id = aws_eip.nat[0].id
  subnet_id     = aws_subnet.public[0].id
  tags = merge(
    local.tags,
    {
      "Name" = "${var.project_name}-nat-gw"
    },
  )
  depends_on = [aws_internet_gateway.this]
}

resource "aws_route_table" "private" {
  count = var.create_vpc && var.enable_nat_gateway ? 1 : 0

  vpc_id = local.vpc_id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[0].id
  }
  tags = merge(
    local.tags,
    {
      "Name" = "${var.project_name}-private-rt"
    },
  )
}

resource "aws_route_table_association" "private" {
  count = var.create_vpc && var.enable_nat_gateway ? length(var.private_subnets) : 0

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[0].id
}

# --- VPC Flow Logs ---
data "aws_iam_policy_document" "flow_logs_assume_role" {
  count = var.enable_flow_logs ? 1 : 0
  statement {
    sid    = "VPCFlowLogsAssumeRole"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "flow_logs" {
  count              = var.enable_flow_logs ? 1 : 0
  name               = "${var.project_name}-${var.environment}-flow-logs-role"
  assume_role_policy = data.aws_iam_policy_document.flow_logs_assume_role[0].json
  tags               = local.tags
}

resource "aws_cloudwatch_log_group" "flow_logs" {
  count             = var.enable_flow_logs ? 1 : 0
  name              = "/aws/vpc-flow-logs/${var.project_name}-${var.environment}"
  retention_in_days = var.flow_logs_retention_in_days
  tags              = local.tags
}

resource "aws_flow_log" "this" {
  count           = var.enable_flow_logs ? 1 : 0
  iam_role_arn    = aws_iam_role.flow_logs[0].arn
  log_destination = aws_cloudwatch_log_group.flow_logs[0].arn
  traffic_type    = "ALL"
  vpc_id          = local.vpc_id
  tags            = local.tags
  depends_on      = [aws_iam_role.flow_logs]
}

# ============================================
# VPC ENDPOINTS
# ============================================

# S3 Gateway Endpoint (sem custo adicional)
resource "aws_vpc_endpoint" "s3" {
  count = var.enable_vpc_endpoints ? 1 : 0

  vpc_id       = local.vpc_id
  service_name = "com.amazonaws.${data.aws_region.current.name}.s3"
  route_table_ids = concat(
    aws_route_table.private[*].id,
    [aws_route_table.public[0].id]
  )

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-s3-endpoint"
    }
  )
}

# ECR API Interface Endpoint
resource "aws_vpc_endpoint" "ecr_api" {
  count = var.enable_vpc_endpoints ? 1 : 0

  vpc_id              = local.vpc_id
  service_name        = "com.amazonaws.${data.aws_region.current.name}.ecr.api"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = aws_subnet.private[*].id
  security_group_ids  = var.vpc_endpoint_security_group_ids
  private_dns_enabled = true

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-ecr-api-endpoint"
    }
  )
}

# ECR DKR Interface Endpoint
resource "aws_vpc_endpoint" "ecr_dkr" {
  count = var.enable_vpc_endpoints ? 1 : 0

  vpc_id              = local.vpc_id
  service_name        = "com.amazonaws.${data.aws_region.current.name}.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = aws_subnet.private[*].id
  security_group_ids  = var.vpc_endpoint_security_group_ids
  private_dns_enabled = true

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-ecr-dkr-endpoint"
    }
  )
}

# SSM Interface Endpoint
resource "aws_vpc_endpoint" "ssm" {
  count = var.enable_vpc_endpoints ? 1 : 0

  vpc_id              = local.vpc_id
  service_name        = "com.amazonaws.${data.aws_region.current.name}.ssm"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = aws_subnet.private[*].id
  security_group_ids  = var.vpc_endpoint_security_group_ids
  private_dns_enabled = true

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-ssm-endpoint"
    }
  )
}

# SSM Messages Interface Endpoint
resource "aws_vpc_endpoint" "ssm_messages" {
  count = var.enable_vpc_endpoints ? 1 : 0

  vpc_id              = local.vpc_id
  service_name        = "com.amazonaws.${data.aws_region.current.name}.ssmmessages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = aws_subnet.private[*].id
  security_group_ids  = var.vpc_endpoint_security_group_ids
  private_dns_enabled = true

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-ssm-messages-endpoint"
    }
  )
}

# EC2 Messages Interface Endpoint
resource "aws_vpc_endpoint" "ec2_messages" {
  count = var.enable_vpc_endpoints ? 1 : 0

  vpc_id              = local.vpc_id
  service_name        = "com.amazonaws.${data.aws_region.current.name}.ec2messages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = aws_subnet.private[*].id
  security_group_ids  = var.vpc_endpoint_security_group_ids
  private_dns_enabled = true

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-ec2-messages-endpoint"
    }
  )
}