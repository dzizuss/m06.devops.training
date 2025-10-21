output "bucket_name" {
  description = "The name of the S3 bucket created"
  value       = aws_s3_bucket.example.bucket
}

output "bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = aws_s3_bucket.example.arn
}

output "bucket_domain" {
  description = "The bucket's domain name"
  value       = aws_s3_bucket.example.bucket_domain_name
}

