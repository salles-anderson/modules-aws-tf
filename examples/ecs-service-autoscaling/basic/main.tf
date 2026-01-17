module "ecs_service_autoscaling" {
  source = "../../../modules/compute/ecs-service-autoscaling"

  project_name = "ecs-demo"
  cluster_name = "demo-cluster"
  service_name = "web"
  min_capacity = 1
  max_capacity = 4
}

output "autoscaling_target_arn" {
  value = module.ecs_service_autoscaling.autoscaling_target_arn
}

output "resource_id" {
  value = module.ecs_service_autoscaling.resource_id
}
