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

variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
  default     = "website"
}

