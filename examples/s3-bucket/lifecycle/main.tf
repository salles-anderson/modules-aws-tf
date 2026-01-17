module "s3_lifecycle" {
  source = "../../../modules/storage/s3-bucket"

  bucket_name = "my-secure-bucket-demo-lifecycle"

  lifecycle_rule_enabled             = true
  noncurrent_version_transition_days = 60
  noncurrent_version_expiration_days = 180
}

output "bucket_name" {
  value = module.s3_lifecycle.bucket_id
}
