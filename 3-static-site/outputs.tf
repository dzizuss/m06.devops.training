output "website_url" {
  value       = "http://${var.bucket_name}.s3-website.localhost.localstack.cloud:4566"
  description = "Open this in your browser once apply completes."
}
