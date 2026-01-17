# =============================================================================
# Kong Gateway Module - CloudWatch Logs
# =============================================================================

resource "aws_cloudwatch_log_group" "kong" {
  name              = "/ecs/${var.name_prefix}-kong"
  retention_in_days = var.log_retention_days

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-kong-logs"
  })
}
