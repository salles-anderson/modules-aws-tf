locals {
  tags = merge(
    {
      "Project" = var.project_name
    },
    var.tags,
  )
}

resource "aws_eip" "this" {
  domain = "vpc"

  tags = merge(
    local.tags,
    {
      "Name" = var.name
    }
  )
}

resource "aws_eip_association" "this" {
  count = var.instance_id != null ? 1 : 0

  instance_id   = var.instance_id
  allocation_id = aws_eip.this.id
}