output "bucket_id" {
  description = "O nome (ID) do bucket S3."
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "O ARN (Amazon Resource Name) do bucket S3."
  value       = aws_s3_bucket.this.arn
}

output "bucket_domain_name" {
  description = "O nome de domínio do bucket S3, para ser usado em outros recursos (ex: CloudFront)."
  value       = aws_s3_bucket.this.bucket_domain_name
}
