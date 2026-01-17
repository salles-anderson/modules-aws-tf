module "s3_basic" {
  source = "../../../modules/storage/s3-bucket"

  bucket_name = "my-secure-bucket-demo-basic"
}

output "bucket_name" {
  value = module.s3_basic.bucket_id
}
