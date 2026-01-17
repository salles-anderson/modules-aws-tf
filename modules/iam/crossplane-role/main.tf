locals {
  tags = merge(
    {
      "Project" = var.project_name
    },
    var.tags,
  )
}

data "aws_iam_policy_document" "assume_role_with_oidc" {
  statement {
    sid     = "AllowOIDCProviderToAssumeRole"
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [var.cluster_oidc_provider_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${var.cluster_oidc_provider_url}:sub"
      values   = ["system:serviceaccount:${var.crossplane_namespace}:${var.crossplane_service_account}"]
    }
  }
}

resource "aws_iam_role" "crossplane" {
  name               = "${var.project_name}-crossplane-role"
  description        = "IAM Role para o Crossplane gerenciar recursos AWS via IRSA"
  assume_role_policy = data.aws_iam_policy_document.assume_role_with_oidc.json
  tags               = local.tags
}

resource "aws_iam_role_policy_attachment" "crossplane_permissions" {
  count      = var.policy_arn != null ? 1 : 0
  role       = aws_iam_role.crossplane.name
  policy_arn = var.policy_arn
}