output "table_name" {
  description = "Name of the DynamoDB table"
  value       = aws_dynamodb_table.example.name
}

output "table_arn" {
  description = "ARN of the DynamoDB table"
  value       = aws_dynamodb_table.example.arn
}

output "hash_key" {
  description = "Partition key configured for the table"
  value       = aws_dynamodb_table.example.hash_key
}
