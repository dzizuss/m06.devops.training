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

variable "os_image" {
  description = "OS image for the VM"
  type        = string
  default     = "ami-04e914639d0cca79a"
}

variable "machine_size" {
  description = "Size of the VM"
  type        = string
  default     = "t2.micro"
}

variable "machine_name" {
  description = "Name of the VM"
  type        = string
  default     = "jesus-christ"
}

