module "k8s_role" {
  source = "../../../modules/iam/k8s-node-role"

  project_name = "k8s-demo"
}

output "role_arn" {
  value = module.k8s_role.iam_role_arn
}

output "profile_name" {
  value = module.k8s_role.instance_profile_name
}
