variable "AWS_ACCESS_KEY_ID" {
  description = "Access key for the AWS (LocalStack) account"
  type        = string
}

variable "AWS_SECRET_ACCESS_KEY" {
  description = "Secret key for the AWS (LocalStack) account"
  type        = string
}

variable "AWS_DEFAULT_REGION" {
  description = "Default region used for the AWS (LocalStack) provider"
  type        = string
  default     = "us-east-1"
}

variable "localstack_endpoint" {
  description = "Base URL for the LocalStack instance exposing AWS service endpoints"
  type        = string
  default     = "http://devops.tomfern.com:31566"
}

variable "db_identifier" {
  description = "Identifier for the training RDS instance"
  type        = string
  default     = "training-rds"
}

variable "db_name" {
  description = "Initial database name to create on the RDS instance"
  type        = string
  default     = "training_app"
}

variable "db_username" {
  description = "Master username for the RDS instance"
  type        = string
  default     = "training_user"
}

variable "db_password" {
  description = "Master password for the RDS instance"
  type        = string
  default     = "training_password"
  sensitive   = true
}

variable "db_instance_class" {
  description = "Instance class used for the RDS instance"
  type        = string
  default     = "db.t3.micro"
}

variable "db_engine_version" {
  description = "PostgreSQL engine version to use"
  type        = string
  default     = "14.7"
}

variable "db_port" {
  description = "Database port to expose"
  type        = number
  default     = 5432
}

variable "db_allocated_storage" {
  description = "Allocated storage in gigabytes for the RDS instance"
  type        = number
  default     = 20
}

variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed to reach the database"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

