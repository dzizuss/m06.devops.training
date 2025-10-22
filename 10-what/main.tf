provider "aws" {
  region     = var.AWS_DEFAULT_REGION
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY

  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_requesting_account_id  = true
  s3_force_path_style         = true

  endpoints {
    s3  = var.localstack_endpoint
    sts = var.localstack_endpoint
    iam = var.localstack_endpoint
    ec2 = var.localstack_endpoint
    rds = var.localstack_endpoint
  }
}

locals {
  az_suffixes = ["a", "b"]
  subnet_cidrs = {
    a = "10.20.1.0/24"
    b = "10.20.2.0/24"
  }
}

resource "aws_vpc" "rds" {
  cidr_block           = "10.20.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.db_identifier}-vpc"
  }
}

resource "aws_subnet" "rds" {
  for_each = local.subnet_cidrs

  vpc_id                  = aws_vpc.rds.id
  cidr_block              = each.value
  availability_zone       = "${var.AWS_DEFAULT_REGION}${each.key}"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.db_identifier}-subnet-${each.key}"
  }
}

resource "aws_security_group" "rds" {
  name        = "${var.db_identifier}-sg"
  description = "Allow connections to the training RDS instance"
  vpc_id      = aws_vpc.rds.id

  ingress {
    description = "PostgreSQL from allowed networks"
    from_port   = var.db_port
    to_port     = var.db_port
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.db_identifier}-sg"
  }
}

resource "aws_db_subnet_group" "rds" {
  name       = "${var.db_identifier}-subnet-group"
  subnet_ids = [for subnet in aws_subnet.rds : subnet.id]

  tags = {
    Name = "${var.db_identifier}-subnet-group"
  }
}

resource "aws_db_instance" "training" {
  identifier                 = var.db_identifier
  engine                     = "postgres"
  engine_version             = var.db_engine_version
  instance_class             = var.db_instance_class
  allocated_storage          = var.db_allocated_storage
  db_name                    = var.db_name
  username                   = var.db_username
  password                   = var.db_password
  port                       = var.db_port
  db_subnet_group_name       = aws_db_subnet_group.rds.name
  vpc_security_group_ids     = [aws_security_group.rds.id]
  publicly_accessible        = true
  storage_type               = "gp2"
  apply_immediately          = true
  auto_minor_version_upgrade = false
  deletion_protection        = false
  skip_final_snapshot        = true

  tags = {
    Name        = var.db_identifier
    Environment = "training"
  }
}

