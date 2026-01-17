module "crossplane_role" {
  source = "../../../modules/iam/crossplane-role"

  project_name              = "crossplane-demo"
  cluster_oidc_provider_arn = "arn:aws:iam::123456789012:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/EXAMPLE123"
  cluster_oidc_provider_url = "oidc.eks.us-east-1.amazonaws.com/id/EXAMPLE123"
  policy_arn                = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess" # Exemplo de política
}

output "role_arn" {
  value = module.crossplane_role.iam_role_arn
}
