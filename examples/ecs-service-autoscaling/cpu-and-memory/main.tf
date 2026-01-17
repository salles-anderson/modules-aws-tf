module "ecs_service_autoscaling" {
  source = "../../../modules/compute/ecs-service-autoscaling"

  project_name          = "ecs-demo"
  cluster_name          = "prod-cluster"
  service_name          = "api"
  min_capacity          = 2
  max_capacity          = 20
  enable_cpu_scaling    = true
  cpu_target_value      = 55
  enable_memory_scaling = true
  memory_target_value   = 65
  scale_in_cooldown     = 300
  scale_out_cooldown    = 90
  disable_scale_in      = false
}

output "autoscaling_target_arn" {
  value = module.ecs_service_autoscaling.autoscaling_target_arn
}

output "cpu_policy_arn" {
  value = module.ecs_service_autoscaling.cpu_policy_arn
}

output "memory_policy_arn" {
  value = module.ecs_service_autoscaling.memory_policy_arn
}
