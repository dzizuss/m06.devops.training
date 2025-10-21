provider "aws" {
  region     = "us-east-1"
  access_key = "test"       # Dummy credentials for LocalStack
  secret_key = "test"
  s3_force_path_style      = true
  endpoints {
    s3 = "http://localhost:4566"  # Ensure this matches your LocalStack endpoint
    sts = "http://localhost:4566"
  }
}

resource "aws_s3_bucket" "example" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_acl" "example_acl" {
  bucket = aws_s3_bucket.example.id
  acl    = "private"
}

