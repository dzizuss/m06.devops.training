# provider "aws" {
#   region     = "us-east-1"
#   access_key = "test"       # Dummy credentials for LocalStack
#   secret_key = "test"
#   s3_force_path_style      = true
#   endpoints {
#     s3 = "http://devops.tomfern.com:4566"  # Ensure this matches your LocalStack endpoint
#     sts = "http://devops.tomfern.com:4566"
#   }
# }

provider "aws" {

  # should take this from environment!
  # region     = "us-east-1"
  # access_key = "LSIAQAAAAAAVNCBMPNSG"
  # secret_key = "LSIAQAAAAAAVNCBMPNSG"

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
    s3   = "http://devops.tomfern.com:31566"
    sts  = "http://devops.tomfern.com:31566"
    iam  = "http://devops.tomfern.com:31566"
    ec2  = "http://devops.tomfern.com:31566"
    sqs  = "http://devops.tomfern.com:31566"
    sns  = "http://devops.tomfern.com:31566"
    # add any other services you use
  }
}

resource "aws_s3_bucket" "example" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_acl" "example_acl" {
  bucket = aws_s3_bucket.example.id
  acl    = "private"
}

