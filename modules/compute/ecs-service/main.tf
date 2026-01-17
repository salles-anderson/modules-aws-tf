locals {
  tags = merge(
    {
      "Project" = var.project_name
    },
    var.tags,
  )
}

resource "aws_ecs_task_definition" "this" {
  family                   = var.name
  network_mode             = var.network_mode
  requires_compatibilities = var.requires_compatibilities
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  execution_role_arn       = var.task_execution_role_arn
  task_role_arn            = var.task_role_arn
  container_definitions    = var.container_definitions

  tags = merge(
    local.tags,
    {
      "Name" = "${var.name}-task"
    }
  )
}

resource "aws_ecs_service" "this" {
  name                   = var.name
  cluster                = var.cluster_id
  task_definition        = aws_ecs_task_definition.this.arn
  desired_count          = var.desired_count
  launch_type            = var.launch_type
  enable_execute_command = var.enable_execute_command
  force_new_deployment   = var.force_new_deployment


  # Apenas para Fargate/awsvpc
  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = var.security_group_ids
    assign_public_ip = var.assign_public_ip
  }

  dynamic "load_balancer" {
    for_each = var.load_balancers
    content {
      target_group_arn = load_balancer.value.target_group_arn
      container_name   = load_balancer.value.container_name
      container_port   = load_balancer.value.container_port
    }
  }

  tags = merge(
    local.tags,
    {
      "Name" = "${var.name}-service"
    }
  )

  # Ignorar mudanças na task_definition para permitir deploy de novas versões fora do Terraform (ex: CI/CD)
  # e também no desired_count para permitir auto-scaling.
  lifecycle {
    ignore_changes = [desired_count]
  }
}