module "iam_role_basic" {
  source = "../../../modules/security/iam-role"

  role_name = "example-role-basic"

  assume_role_policy_json = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  policy_arns = [
    "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  ]
}

output "role_arn" {
  value = module.iam_role_basic.role_arn
}
