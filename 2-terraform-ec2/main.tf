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
    s3   = "http://devops.tomfern.com:31566"
    sts  = "http://devops.tomfern.com:31566"
    iam  = "http://devops.tomfern.com:31566"
    ec2  = "http://devops.tomfern.com:31566"
    sqs  = "http://devops.tomfern.com:31566"
    sns  = "http://devops.tomfern.com:31566"
    # add any other services you use
  }
}

resource "aws_instance" "machine" {
  # ami           = "ami-04e914639d0cca79a"
  # instance_type = "t2.micro"
  ami           = var.os_image
  instance_type = var.machine_size
  tags = {
    Name = var.machine_name
  }
}
