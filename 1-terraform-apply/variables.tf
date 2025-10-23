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

variable "aws_endpoint" {
  description = "Override default endpoint for AWS API"
  type        = string
  default     = "http://devops.tomfern.com:31566"
}

variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
  default     = "team-2-test-bucket-rtrk"
}


