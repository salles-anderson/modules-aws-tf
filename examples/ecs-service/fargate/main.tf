module "ecs_fargate" {
  source = "../../../modules/compute/ecs-service"

  project_name            = "ecs-demo"
  name                    = "nginx-app"
  cluster_id              = "arn:aws:ecs:us-east-1:123456789012:cluster/dummy-cluster"
  task_execution_role_arn = "arn:aws:iam::123456789012:role/ecsTaskExecutionRole"

  task_cpu           = 256
  task_memory        = 512
  subnet_ids         = ["subnet-1", "subnet-2"]
  security_group_ids = ["sg-1"]

  container_definitions = jsonencode([
    {
      name      = "nginx"
      image     = "nginx:alpine"
      essential = true
      portMappings = [
        {
          containerPort = 80
          protocol      = "tcp"
        }
      ]
    }
  ])
}

output "service_name" {
  value = module.ecs_fargate.service_name
}
