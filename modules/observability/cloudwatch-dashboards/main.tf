locals {
  tags = merge(
    {
      Project = var.project_name
    },
    var.tags,
  )
}

# =============================================================================
# Custom Dashboards
# =============================================================================

resource "aws_cloudwatch_dashboard" "custom" {
  for_each = var.dashboards

  dashboard_name = each.key
  dashboard_body = each.value.body
}

# =============================================================================
# ECS Dashboards
# =============================================================================

resource "aws_cloudwatch_dashboard" "ecs" {
  for_each = var.ecs_dashboards

  dashboard_name = each.key
  dashboard_body = templatefile("${path.module}/templates/ecs-dashboard.json.tpl", {
    region         = var.aws_region
    cluster_name   = each.value.cluster_name
    service_names  = each.value.service_names
    dashboard_name = each.key
  })
}

# =============================================================================
# RDS Dashboards
# =============================================================================

resource "aws_cloudwatch_dashboard" "rds" {
  for_each = var.rds_dashboards

  dashboard_name = each.key
  dashboard_body = templatefile("${path.module}/templates/rds-dashboard.json.tpl", {
    region                 = var.aws_region
    db_instance_identifier = each.value.db_instance_identifier
    dashboard_name         = each.key
  })
}

# =============================================================================
# Lambda Dashboards
# =============================================================================

resource "aws_cloudwatch_dashboard" "lambda" {
  for_each = var.lambda_dashboards

  dashboard_name = each.key
  dashboard_body = templatefile("${path.module}/templates/lambda-dashboard.json.tpl", {
    region         = var.aws_region
    function_names = each.value.function_names
    dashboard_name = each.key
  })
}

# =============================================================================
# ALB Dashboards
# =============================================================================

resource "aws_cloudwatch_dashboard" "alb" {
  for_each = var.alb_dashboards

  dashboard_name = each.key
  dashboard_body = templatefile("${path.module}/templates/alb-dashboard.json.tpl", {
    region                   = var.aws_region
    load_balancer_arn_suffix = each.value.load_balancer_arn_suffix
    target_group_arn_suffix  = each.value.target_group_arn_suffix
    dashboard_name           = each.key
  })
}

# =============================================================================
# Overview Dashboard
# =============================================================================

resource "aws_cloudwatch_dashboard" "overview" {
  count = var.create_overview_dashboard ? 1 : 0

  dashboard_name = coalesce(var.overview_dashboard_name, "${var.project_name}-overview")
  dashboard_body = templatefile("${path.module}/templates/overview-dashboard.json.tpl", {
    region           = var.aws_region
    project_name     = var.project_name
    dashboard_name   = coalesce(var.overview_dashboard_name, "${var.project_name}-overview")
    ecs_clusters     = var.overview_ecs_clusters
    rds_instances    = var.overview_rds_instances
    lambda_functions = var.overview_lambda_functions
    alb_arns         = var.overview_alb_arns
  })
}
