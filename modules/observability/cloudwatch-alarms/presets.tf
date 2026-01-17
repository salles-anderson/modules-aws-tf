# =============================================================================
# ECS Service Alarms
# =============================================================================

resource "aws_cloudwatch_metric_alarm" "ecs_cpu" {
  for_each = var.ecs_service_alarms

  alarm_name          = "${each.key}-ecs-cpu-high"
  alarm_description   = "Alarme de CPU alto para o serviço ECS ${each.key}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = lookup(each.value, "cpu_evaluation_periods", 3)
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = lookup(each.value, "cpu_period", 300)
  statistic           = "Average"
  threshold           = lookup(each.value, "cpu_threshold", 80)
  treat_missing_data  = "notBreaching"
  actions_enabled     = lookup(each.value, "actions_enabled", true)

  dimensions = {
    ClusterName = each.value.cluster_name
    ServiceName = each.value.service_name
  }

  alarm_actions             = lookup(each.value, "alarm_actions", local.sns_topic_arns)
  ok_actions                = lookup(each.value, "ok_actions", [])
  insufficient_data_actions = lookup(each.value, "insufficient_data_actions", [])

  tags = merge(
    local.tags,
    lookup(each.value, "tags", {}),
    {
      AlarmType = "ECS-CPU"
    },
  )
}

resource "aws_cloudwatch_metric_alarm" "ecs_memory" {
  for_each = var.ecs_service_alarms

  alarm_name          = "${each.key}-ecs-memory-high"
  alarm_description   = "Alarme de memória alto para o serviço ECS ${each.key}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = lookup(each.value, "memory_evaluation_periods", 3)
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = lookup(each.value, "memory_period", 300)
  statistic           = "Average"
  threshold           = lookup(each.value, "memory_threshold", 80)
  treat_missing_data  = "notBreaching"
  actions_enabled     = lookup(each.value, "actions_enabled", true)

  dimensions = {
    ClusterName = each.value.cluster_name
    ServiceName = each.value.service_name
  }

  alarm_actions             = lookup(each.value, "alarm_actions", local.sns_topic_arns)
  ok_actions                = lookup(each.value, "ok_actions", [])
  insufficient_data_actions = lookup(each.value, "insufficient_data_actions", [])

  tags = merge(
    local.tags,
    lookup(each.value, "tags", {}),
    {
      AlarmType = "ECS-Memory"
    },
  )
}

# =============================================================================
# RDS Alarms
# =============================================================================

resource "aws_cloudwatch_metric_alarm" "rds_cpu" {
  for_each = var.rds_alarms

  alarm_name          = "${each.key}-rds-cpu-high"
  alarm_description   = "Alarme de CPU alto para o RDS ${each.key}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = lookup(each.value, "cpu_evaluation_periods", 3)
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = lookup(each.value, "cpu_period", 300)
  statistic           = "Average"
  threshold           = lookup(each.value, "cpu_threshold", 80)
  treat_missing_data  = "notBreaching"
  actions_enabled     = lookup(each.value, "actions_enabled", true)

  dimensions = {
    DBInstanceIdentifier = each.value.db_instance_identifier
  }

  alarm_actions             = lookup(each.value, "alarm_actions", local.sns_topic_arns)
  ok_actions                = lookup(each.value, "ok_actions", [])
  insufficient_data_actions = lookup(each.value, "insufficient_data_actions", [])

  tags = merge(
    local.tags,
    lookup(each.value, "tags", {}),
    {
      AlarmType = "RDS-CPU"
    },
  )
}

resource "aws_cloudwatch_metric_alarm" "rds_memory" {
  for_each = var.rds_alarms

  alarm_name          = "${each.key}-rds-freeable-memory-low"
  alarm_description   = "Alarme de memória livre baixa para o RDS ${each.key}"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = lookup(each.value, "memory_evaluation_periods", 3)
  metric_name         = "FreeableMemory"
  namespace           = "AWS/RDS"
  period              = lookup(each.value, "memory_period", 300)
  statistic           = "Average"
  threshold           = lookup(each.value, "memory_threshold_bytes", 256 * 1024 * 1024) # 256MB default
  treat_missing_data  = "notBreaching"
  actions_enabled     = lookup(each.value, "actions_enabled", true)

  dimensions = {
    DBInstanceIdentifier = each.value.db_instance_identifier
  }

  alarm_actions             = lookup(each.value, "alarm_actions", local.sns_topic_arns)
  ok_actions                = lookup(each.value, "ok_actions", [])
  insufficient_data_actions = lookup(each.value, "insufficient_data_actions", [])

  tags = merge(
    local.tags,
    lookup(each.value, "tags", {}),
    {
      AlarmType = "RDS-Memory"
    },
  )
}

resource "aws_cloudwatch_metric_alarm" "rds_storage" {
  for_each = var.rds_alarms

  alarm_name          = "${each.key}-rds-free-storage-low"
  alarm_description   = "Alarme de espaço livre baixo para o RDS ${each.key}"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = lookup(each.value, "storage_evaluation_periods", 3)
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = lookup(each.value, "storage_period", 300)
  statistic           = "Average"
  threshold           = lookup(each.value, "storage_threshold_bytes", 5 * 1024 * 1024 * 1024) # 5GB default
  treat_missing_data  = "notBreaching"
  actions_enabled     = lookup(each.value, "actions_enabled", true)

  dimensions = {
    DBInstanceIdentifier = each.value.db_instance_identifier
  }

  alarm_actions             = lookup(each.value, "alarm_actions", local.sns_topic_arns)
  ok_actions                = lookup(each.value, "ok_actions", [])
  insufficient_data_actions = lookup(each.value, "insufficient_data_actions", [])

  tags = merge(
    local.tags,
    lookup(each.value, "tags", {}),
    {
      AlarmType = "RDS-Storage"
    },
  )
}

resource "aws_cloudwatch_metric_alarm" "rds_connections" {
  for_each = var.rds_alarms

  alarm_name          = "${each.key}-rds-connections-high"
  alarm_description   = "Alarme de conexões altas para o RDS ${each.key}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = lookup(each.value, "connections_evaluation_periods", 3)
  metric_name         = "DatabaseConnections"
  namespace           = "AWS/RDS"
  period              = lookup(each.value, "connections_period", 300)
  statistic           = "Average"
  threshold           = lookup(each.value, "connections_threshold", 100)
  treat_missing_data  = "notBreaching"
  actions_enabled     = lookup(each.value, "actions_enabled", true)

  dimensions = {
    DBInstanceIdentifier = each.value.db_instance_identifier
  }

  alarm_actions             = lookup(each.value, "alarm_actions", local.sns_topic_arns)
  ok_actions                = lookup(each.value, "ok_actions", [])
  insufficient_data_actions = lookup(each.value, "insufficient_data_actions", [])

  tags = merge(
    local.tags,
    lookup(each.value, "tags", {}),
    {
      AlarmType = "RDS-Connections"
    },
  )
}

# =============================================================================
# Lambda Alarms
# =============================================================================

resource "aws_cloudwatch_metric_alarm" "lambda_errors" {
  for_each = var.lambda_alarms

  alarm_name          = "${each.key}-lambda-errors"
  alarm_description   = "Alarme de erros para a função Lambda ${each.key}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = lookup(each.value, "errors_evaluation_periods", 1)
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = lookup(each.value, "errors_period", 300)
  statistic           = "Sum"
  threshold           = lookup(each.value, "errors_threshold", 0)
  treat_missing_data  = "notBreaching"
  actions_enabled     = lookup(each.value, "actions_enabled", true)

  dimensions = {
    FunctionName = each.value.function_name
  }

  alarm_actions             = lookup(each.value, "alarm_actions", local.sns_topic_arns)
  ok_actions                = lookup(each.value, "ok_actions", [])
  insufficient_data_actions = lookup(each.value, "insufficient_data_actions", [])

  tags = merge(
    local.tags,
    lookup(each.value, "tags", {}),
    {
      AlarmType = "Lambda-Errors"
    },
  )
}

resource "aws_cloudwatch_metric_alarm" "lambda_duration" {
  for_each = var.lambda_alarms

  alarm_name          = "${each.key}-lambda-duration-high"
  alarm_description   = "Alarme de duração alta para a função Lambda ${each.key}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = lookup(each.value, "duration_evaluation_periods", 3)
  metric_name         = "Duration"
  namespace           = "AWS/Lambda"
  period              = lookup(each.value, "duration_period", 300)
  statistic           = "Average"
  threshold           = lookup(each.value, "duration_threshold_ms", 5000)
  treat_missing_data  = "notBreaching"
  actions_enabled     = lookup(each.value, "actions_enabled", true)

  dimensions = {
    FunctionName = each.value.function_name
  }

  alarm_actions             = lookup(each.value, "alarm_actions", local.sns_topic_arns)
  ok_actions                = lookup(each.value, "ok_actions", [])
  insufficient_data_actions = lookup(each.value, "insufficient_data_actions", [])

  tags = merge(
    local.tags,
    lookup(each.value, "tags", {}),
    {
      AlarmType = "Lambda-Duration"
    },
  )
}

resource "aws_cloudwatch_metric_alarm" "lambda_throttles" {
  for_each = var.lambda_alarms

  alarm_name          = "${each.key}-lambda-throttles"
  alarm_description   = "Alarme de throttling para a função Lambda ${each.key}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = lookup(each.value, "throttles_evaluation_periods", 1)
  metric_name         = "Throttles"
  namespace           = "AWS/Lambda"
  period              = lookup(each.value, "throttles_period", 300)
  statistic           = "Sum"
  threshold           = lookup(each.value, "throttles_threshold", 0)
  treat_missing_data  = "notBreaching"
  actions_enabled     = lookup(each.value, "actions_enabled", true)

  dimensions = {
    FunctionName = each.value.function_name
  }

  alarm_actions             = lookup(each.value, "alarm_actions", local.sns_topic_arns)
  ok_actions                = lookup(each.value, "ok_actions", [])
  insufficient_data_actions = lookup(each.value, "insufficient_data_actions", [])

  tags = merge(
    local.tags,
    lookup(each.value, "tags", {}),
    {
      AlarmType = "Lambda-Throttles"
    },
  )
}

# =============================================================================
# ALB Alarms
# =============================================================================

resource "aws_cloudwatch_metric_alarm" "alb_5xx" {
  for_each = var.alb_alarms

  alarm_name          = "${each.key}-alb-5xx-errors"
  alarm_description   = "Alarme de erros 5XX para o ALB ${each.key}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = lookup(each.value, "error_5xx_evaluation_periods", 3)
  metric_name         = "HTTPCode_ELB_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = lookup(each.value, "error_5xx_period", 300)
  statistic           = "Sum"
  threshold           = lookup(each.value, "error_5xx_threshold", 10)
  treat_missing_data  = "notBreaching"
  actions_enabled     = lookup(each.value, "actions_enabled", true)

  dimensions = {
    LoadBalancer = each.value.load_balancer_arn_suffix
  }

  alarm_actions             = lookup(each.value, "alarm_actions", local.sns_topic_arns)
  ok_actions                = lookup(each.value, "ok_actions", [])
  insufficient_data_actions = lookup(each.value, "insufficient_data_actions", [])

  tags = merge(
    local.tags,
    lookup(each.value, "tags", {}),
    {
      AlarmType = "ALB-5XX"
    },
  )
}

resource "aws_cloudwatch_metric_alarm" "alb_unhealthy" {
  for_each = var.alb_alarms

  alarm_name          = "${each.key}-alb-unhealthy-hosts"
  alarm_description   = "Alarme de hosts não saudáveis para o ALB ${each.key}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = lookup(each.value, "unhealthy_evaluation_periods", 2)
  metric_name         = "UnHealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = lookup(each.value, "unhealthy_period", 300)
  statistic           = "Average"
  threshold           = lookup(each.value, "unhealthy_threshold", 0)
  treat_missing_data  = "notBreaching"
  actions_enabled     = lookup(each.value, "actions_enabled", true)

  dimensions = {
    LoadBalancer = each.value.load_balancer_arn_suffix
    TargetGroup  = each.value.target_group_arn_suffix
  }

  alarm_actions             = lookup(each.value, "alarm_actions", local.sns_topic_arns)
  ok_actions                = lookup(each.value, "ok_actions", [])
  insufficient_data_actions = lookup(each.value, "insufficient_data_actions", [])

  tags = merge(
    local.tags,
    lookup(each.value, "tags", {}),
    {
      AlarmType = "ALB-UnhealthyHosts"
    },
  )
}

resource "aws_cloudwatch_metric_alarm" "alb_latency" {
  for_each = var.alb_alarms

  alarm_name          = "${each.key}-alb-latency-high"
  alarm_description   = "Alarme de latência alta para o ALB ${each.key}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = lookup(each.value, "latency_evaluation_periods", 3)
  metric_name         = "TargetResponseTime"
  namespace           = "AWS/ApplicationELB"
  period              = lookup(each.value, "latency_period", 300)
  statistic           = "Average"
  threshold           = lookup(each.value, "latency_threshold_seconds", 1)
  treat_missing_data  = "notBreaching"
  actions_enabled     = lookup(each.value, "actions_enabled", true)

  dimensions = {
    LoadBalancer = each.value.load_balancer_arn_suffix
  }

  alarm_actions             = lookup(each.value, "alarm_actions", local.sns_topic_arns)
  ok_actions                = lookup(each.value, "ok_actions", [])
  insufficient_data_actions = lookup(each.value, "insufficient_data_actions", [])

  tags = merge(
    local.tags,
    lookup(each.value, "tags", {}),
    {
      AlarmType = "ALB-Latency"
    },
  )
}
