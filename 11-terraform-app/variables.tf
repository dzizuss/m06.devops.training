variable "AWS_ACCESS_KEY_ID" {
  description = "Access ID to the AWS (LocalStack) Account"
  type        = string
}

variable "AWS_SECRET_ACCESS_KEY" {
  description = "Access token to the AWS (LocalStack) Account"
  type        = string
}

variable "AWS_DEFAULT_REGION" {
  description = "Default region for the AWS (LocalStack)"
  type        = string
  default     = "us-east-1"
}

variable "localstack_edge_url" {
  description = "Edge endpoint for LocalStack services."
  type        = string
  default     = "http://host.docker.internal:4566"
}

variable "dynamodb_table_name" {
  description = "Name of the DynamoDB table that backs the demo application."
  type        = string
  default     = "terraform-training-items"
}

variable "app_host_port" {
  description = "Port exposed on the host for the Flask application."
  type        = number
  default     = 30040
}

variable "docker_host" {
  description = "Docker daemon host used by the Terraform Docker provider."
  type        = string
  default     = "unix:///var/run/docker.sock"
}
