provider "aws" {

  region = var.AWS_DEFAULT_REGION
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY

  # Make Terraform play nice with LocalStack
  skip_credentials_validation    = true
  skip_metadata_api_check        = true
  skip_region_validation         = true
  skip_requesting_account_id     = true
  s3_force_path_style            = true

  endpoints {
    s3   = var.aws_endpoint
    sts  = var.aws_endpoint
    iam  = var.aws_endpoint
    ec2  = var.aws_endpoint
    sqs  = var.aws_endpoint
    sns  = var.aws_endpoint
  }
}

resource "aws_s3_bucket" "example" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_acl" "example_acl" {
  bucket = aws_s3_bucket.example.id
  acl    = "private"
}

