# =============================================================================
# Kong Gateway Module - ECS Task Definition + Service
# =============================================================================

locals {
  container_name = "kong"

  # Gera configuração declarativa do Kong automaticamente
  kong_declarative_config = var.kong_custom_config != null ? var.kong_custom_config : yamlencode({
    _format_version = "3.0"
    _transform      = true

    services = [
      {
        name            = "api-backend"
        url             = "${var.backend_protocol}://${var.backend_host}:${var.backend_port}${var.backend_path_prefix}"
        protocol        = var.backend_protocol
        connect_timeout = 60000
        write_timeout   = 60000
        read_timeout    = 60000
        retries         = 3

        routes = [
          {
            name          = "api-route"
            paths         = var.routing_paths
            strip_path    = false
            preserve_host = true
            protocols     = ["http", "https"]
          }
        ]
      }
    ]

    plugins = [
      {
        name = "correlation-id"
        config = {
          header_name     = "X-Correlation-ID"
          generator       = "uuid"
          echo_downstream = true
        }
      },
      {
        name = "file-log"
        config = {
          path   = "/dev/stdout"
          reopen = true
        }
      }
    ]
  })

  # Variáveis de ambiente base do Kong
  kong_base_env = [
    { name = "KONG_DATABASE", value = "off" },
    { name = "KONG_PROXY_LISTEN", value = "0.0.0.0:${var.kong_proxy_port}" },
    { name = "KONG_ADMIN_LISTEN", value = "0.0.0.0:${var.kong_admin_port}" },
    { name = "KONG_PROXY_ACCESS_LOG", value = "/dev/stdout" },
    { name = "KONG_ADMIN_ACCESS_LOG", value = "/dev/stdout" },
    { name = "KONG_PROXY_ERROR_LOG", value = "/dev/stderr" },
    { name = "KONG_ADMIN_ERROR_LOG", value = "/dev/stderr" },
    { name = "KONG_LOG_LEVEL", value = var.kong_log_level },
    { name = "KONG_PLUGINS", value = var.kong_plugins },
    # Configuração declarativa inline
    { name = "KONG_DECLARATIVE_CONFIG_STRING", value = local.kong_declarative_config },
  ]

  # Variáveis de Redis (se habilitado)
  kong_redis_env = var.enable_redis && var.redis_endpoint != null ? [
    { name = "KONG_REDIS_HOST", value = var.redis_endpoint },
    { name = "KONG_REDIS_PORT", value = tostring(var.redis_port) },
    { name = "KONG_REDIS_SSL", value = tostring(var.redis_ssl) },
  ] : []

  # Merge de todas as variáveis de ambiente
  kong_environment = concat(
    local.kong_base_env,
    local.kong_redis_env,
    var.kong_extra_env
  )
}

# =============================================================================
# ECS Task Definition
# =============================================================================

resource "aws_ecs_task_definition" "kong" {
  family                   = "${var.name_prefix}-kong"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.kong_cpu
  memory                   = var.kong_memory
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn

  container_definitions = jsonencode([
    {
      name      = local.container_name
      image     = var.kong_image
      essential = true

      portMappings = [
        {
          containerPort = var.kong_proxy_port
          protocol      = "tcp"
        },
        {
          containerPort = var.kong_admin_port
          protocol      = "tcp"
        }
      ]

      environment = local.kong_environment

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.kong.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = local.container_name
        }
      }

      healthCheck = {
        command     = ["CMD-SHELL", "kong health"]
        interval    = 30
        timeout     = 5
        retries     = 3
        startPeriod = 60
      }
    }
  ])

  tags = var.tags
}

# =============================================================================
# ECS Service
# =============================================================================

resource "aws_ecs_service" "kong" {
  name                              = "${var.name_prefix}-kong"
  cluster                           = var.ecs_cluster_arn
  task_definition                   = aws_ecs_task_definition.kong.arn
  desired_count                     = var.desired_count
  launch_type                       = "FARGATE"
  enable_execute_command            = var.enable_execute_command
  health_check_grace_period_seconds = 60

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = [aws_security_group.kong.id]
    assign_public_ip = var.assign_public_ip
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.kong.arn
    container_name   = local.container_name
    container_port   = var.kong_proxy_port
  }

  lifecycle {
    ignore_changes = [desired_count]
  }

  tags = var.tags

  depends_on = [
    aws_cloudwatch_log_group.kong,
    aws_lb_target_group.kong,
  ]
}

# =============================================================================
# Auto Scaling (opcional)
# =============================================================================

resource "aws_appautoscaling_target" "kong" {
  count              = var.enable_autoscaling ? 1 : 0
  max_capacity       = var.max_capacity
  min_capacity       = var.min_capacity
  resource_id        = "service/${split("/", var.ecs_cluster_arn)[1]}/${aws_ecs_service.kong.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "kong_cpu" {
  count              = var.enable_autoscaling ? 1 : 0
  name               = "${var.name_prefix}-kong-cpu"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.kong[0].resource_id
  scalable_dimension = aws_appautoscaling_target.kong[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.kong[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value       = var.cpu_target
    scale_in_cooldown  = 300
    scale_out_cooldown = 60
  }
}

resource "aws_appautoscaling_policy" "kong_memory" {
  count              = var.enable_autoscaling ? 1 : 0
  name               = "${var.name_prefix}-kong-memory"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.kong[0].resource_id
  scalable_dimension = aws_appautoscaling_target.kong[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.kong[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
    target_value       = var.memory_target
    scale_in_cooldown  = 300
    scale_out_cooldown = 60
  }
}
