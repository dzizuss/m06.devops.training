provider "aws" {

  region = var.AWS_DEFAULT_REGION
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY

  # Make Terraform play nice with LocalStack
  skip_credentials_validation    = true
  skip_metadata_api_check        = true
  skip_region_validation         = true
  skip_requesting_account_id     = true
  # s3_force_path_style            = true

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

resource "aws_s3_bucket" "site" {
  bucket = var.bucket_name
}

# resource "aws_s3_bucket_acl" "example_acl" {
#   bucket = aws_s3_bucket.example.id
#   acl    = "private"
# }
#
# Enable static website hosting
resource "aws_s3_bucket_website_configuration" "site" {
  bucket = aws_s3_bucket.site.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# Allow public reads (required for website hosting)
data "aws_iam_policy_document" "public_read" {
  statement {
    sid = "PublicReadGetObject"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.site.arn}/*"]
  }
}

resource "aws_s3_bucket_policy" "public_read" {
  bucket = aws_s3_bucket.site.id
  policy = data.aws_iam_policy_document.public_read.json
}

# Ensure "block public access" is off
resource "aws_s3_bucket_public_access_block" "site" {
  bucket                  = aws_s3_bucket.site.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Upload site files
# resource "aws_s3_object" "index" {
#   bucket       = aws_s3_bucket.site.id
#   key          = "index.html"
#   source       = "${path.module}/site/index.html"
#   etag         = filemd5("${path.module}/site/index.html")
#   content_type = "text/html"
# }
#
# resource "aws_s3_object" "error" {
#   bucket       = aws_s3_bucket.site.id
#   key          = "error.html"
#   source       = "${path.module}/site/error.html"
#   etag         = filemd5("${path.module}/site/error.html")
#   content_type = "text/html"
# }
