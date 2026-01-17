output "iam_role_arn" {
  description = "O ARN da IAM Role criada para os nós K8s."
  value       = aws_iam_role.k8s_node.arn
}

output "instance_profile_name" {
  description = "O nome do IAM Instance Profile para associar às instâncias EC2."
  value       = aws_iam_instance_profile.k8s_node.name
}