output "application_url" {
  description = "URL where the Flask application is exposed."
  value       = "http://localhost:${var.app_host_port}"
}

output "dynamodb_table_name" {
  description = "DynamoDB table used by the Flask application."
  value       = aws_dynamodb_table.items.name
}
