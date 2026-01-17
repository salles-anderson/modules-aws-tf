module "rke2_agent" {
  source = "../../../modules/compute/ec2-rke2-node"

  project_name              = "rke2-demo"
  cluster_name              = "demo-cluster"
  rke2_role                 = "agent"
  rke2_version              = "v1.28.5+rke2r1"
  rke2_token                = "supersecrettoken"
  instance_type             = "t3.large"
  instance_count            = 2
  subnet_ids                = ["subnet-1", "subnet-2"] # Dummy Subnets
  security_group_ids        = ["sg-12345"]             # Dummy SG
  iam_instance_profile_name = "k8s-role"               # Dummy Role
}

output "agent_ips" {
  value = module.rke2_agent.private_ips
}
