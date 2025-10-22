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
    dynamodb  = "http://devops.tomfern.com:31566"
    # add any other services you use
  }
}

provider "docker" {
  host = var.docker_host
}

resource "aws_dynamodb_table" "items" {
  name         = var.dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "pk"

  attribute {
    name = "pk"
    type = "S"
  }
}

resource "docker_image" "flask_app" {
  name = "terraform-localstack/flask-app:latest"

  build {
    context    = "${path.module}/flask_app"
    dockerfile = "${path.module}/flask_app/Dockerfile"
  }
}

resource "docker_container" "flask_app" {
  name  = "terraform-localstack-flask"
  image = docker_image.flask_app.image_id

  env = [
    "AWS_ACCESS_KEY_ID=${var.AWS_ACCESS_KEY_ID}",
    "AWS_SECRET_ACCESS_KEY=${var.AWS_SECRET_ACCESS_KEY}",
    "AWS_DEFAULT_REGION=${var.AWS_DEFAULT_REGION}",
    "LOCALSTACK_URL=${var.localstack_edge_url}",
    "TABLE_NAME=${aws_dynamodb_table.items.name}"
  ]

  ports {
    internal = 5000
    external = var.app_host_port
  }

  depends_on = [
    aws_dynamodb_table.items
  ]
}
