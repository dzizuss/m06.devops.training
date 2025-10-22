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
  default     = "my-example-machine"
}

variable "ecs_app_name" {
  description = "Base name for the ECS application resources"
  type        = string
  default     = "localstack-ecs-app"
}

variable "ecs_task_image" {
  description = "Container image to deploy onto ECS"
  type        = string
  default     = "public.ecr.aws/docker/library/nginx:latest"
}

variable "ecs_container_port" {
  description = "Port exposed by the container image"
  type        = number
  default     = 80
}

variable "ecs_desired_count" {
  description = "Number of ECS tasks to run for the service"
  type        = number
  default     = 1
}
