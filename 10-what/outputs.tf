output "db_hostname" {
  description = "DNS name to reach the RDS instance"
  value       = aws_db_instance.training.address
}

output "db_port" {
  description = "Port exposed by the database"
  value       = aws_db_instance.training.port
}

output "db_name" {
  description = "Name of the default database"
  value       = aws_db_instance.training.db_name
}

output "db_username" {
  description = "Username to connect to the database"
  value       = aws_db_instance.training.username
}

output "db_password" {
  description = "Password to connect to the database"
  value       = aws_db_instance.training.password
  sensitive   = true
}

output "jdbc_connection_string" {
  description = "Convenience JDBC connection string"
  value       = "jdbc:postgresql://${aws_db_instance.training.address}:${aws_db_instance.training.port}/${aws_db_instance.training.db_name}"
}

