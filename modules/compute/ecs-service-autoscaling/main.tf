locals {
  resource_id        = "service/${var.cluster_name}/${var.service_name}"
  policy_name_prefix = "${var.project_name}-${var.service_name}"
}

resource "aws_appautoscaling_target" "this" {
  service_namespace  = "ecs"
  resource_id        = local.resource_id
  scalable_dimension = "ecs:service:DesiredCount"
  min_capacity       = var.min_capacity
  max_capacity       = var.max_capacity
}

resource "aws_appautoscaling_policy" "cpu" {
  count = var.enable_cpu_scaling ? 1 : 0

  name               = "${local.policy_name_prefix}-cpu-target-tracking"
  policy_type        = "TargetTrackingScaling"
  resource_id        = local.resource_id
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value       = var.cpu_target_value
    scale_in_cooldown  = var.scale_in_cooldown
    scale_out_cooldown = var.scale_out_cooldown
    disable_scale_in   = var.disable_scale_in
  }

  depends_on = [aws_appautoscaling_target.this]
}

resource "aws_appautoscaling_policy" "memory" {
  count = var.enable_memory_scaling ? 1 : 0

  name               = "${local.policy_name_prefix}-memory-target-tracking"
  policy_type        = "TargetTrackingScaling"
  resource_id        = local.resource_id
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value       = var.memory_target_value
    scale_in_cooldown  = var.scale_in_cooldown
    scale_out_cooldown = var.scale_out_cooldown
    disable_scale_in   = var.disable_scale_in
  }

  depends_on = [aws_appautoscaling_target.this]
}

resource "aws_appautoscaling_policy" "alb" {
  count = var.enable_alb_scaling ? 1 : 0

  name               = "${local.policy_name_prefix}-alb-req-per-target"
  policy_type        = "TargetTrackingScaling"
  resource_id        = local.resource_id
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ALBRequestCountPerTarget"
      resource_label         = "${var.alb_load_balancer_arn_suffix}/${var.alb_target_group_arn_suffix}"
    }

    target_value       = var.alb_request_count_target_value
    scale_in_cooldown  = var.scale_in_cooldown
    scale_out_cooldown = var.scale_out_cooldown
    disable_scale_in   = var.disable_scale_in
  }

  depends_on = [aws_appautoscaling_target.this]
}

# =============================================================================
# Scheduled Scaling Actions (Cost Optimization)
# =============================================================================

resource "aws_appautoscaling_scheduled_action" "scale_down" {
  count = var.enable_scheduled_scaling ? 1 : 0

  name               = "${local.policy_name_prefix}-scheduled-scale-down"
  service_namespace  = "ecs"
  resource_id        = aws_appautoscaling_target.this.resource_id
  scalable_dimension = "ecs:service:DesiredCount"
  schedule           = var.scale_down_schedule
  timezone           = var.schedule_timezone

  scalable_target_action {
    min_capacity = var.scale_down_min_capacity
    max_capacity = var.scale_down_max_capacity
  }

  depends_on = [aws_appautoscaling_target.this]
}

resource "aws_appautoscaling_scheduled_action" "scale_up" {
  count = var.enable_scheduled_scaling ? 1 : 0

  name               = "${local.policy_name_prefix}-scheduled-scale-up"
  service_namespace  = "ecs"
  resource_id        = aws_appautoscaling_target.this.resource_id
  scalable_dimension = "ecs:service:DesiredCount"
  schedule           = var.scale_up_schedule
  timezone           = var.schedule_timezone

  scalable_target_action {
    min_capacity = var.min_capacity
    max_capacity = var.max_capacity
  }

  depends_on = [aws_appautoscaling_target.this]
}
