locals {
  ecs_app_name = var.ecs_app_name
}

resource "aws_vpc" "ecs" {
  cidr_block           = "10.10.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${local.ecs_app_name}-vpc"
  }
}

resource "aws_internet_gateway" "ecs" {
  vpc_id = aws_vpc.ecs.id

  tags = {
    Name = "${local.ecs_app_name}-igw"
  }
}

resource "aws_subnet" "ecs_public_a" {
  vpc_id                  = aws_vpc.ecs.id
  cidr_block              = "10.10.1.0/24"
  availability_zone       = "${var.AWS_DEFAULT_REGION}a"
  map_public_ip_on_launch = true

  tags = {
    Name = "${local.ecs_app_name}-public-a"
  }
}

resource "aws_subnet" "ecs_public_b" {
  vpc_id                  = aws_vpc.ecs.id
  cidr_block              = "10.10.2.0/24"
  availability_zone       = "${var.AWS_DEFAULT_REGION}b"
  map_public_ip_on_launch = true

  tags = {
    Name = "${local.ecs_app_name}-public-b"
  }
}

resource "aws_route_table" "ecs_public" {
  vpc_id = aws_vpc.ecs.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ecs.id
  }

  tags = {
    Name = "${local.ecs_app_name}-public-rt"
  }
}

resource "aws_route_table_association" "ecs_public_a" {
  subnet_id      = aws_subnet.ecs_public_a.id
  route_table_id = aws_route_table.ecs_public.id
}

resource "aws_route_table_association" "ecs_public_b" {
  subnet_id      = aws_subnet.ecs_public_b.id
  route_table_id = aws_route_table.ecs_public.id
}

resource "aws_security_group" "ecs_service" {
  name        = "${local.ecs_app_name}-service-sg"
  description = "Permit traffic from the load balancer to the ECS tasks"
  vpc_id      = aws_vpc.ecs.id

  ingress {
    description     = "Allow HTTP from ALB"
    from_port       = var.ecs_container_port
    to_port         = var.ecs_container_port
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs_lb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.ecs_app_name}-service-sg"
  }
}

resource "aws_security_group" "ecs_lb" {
  name        = "${local.ecs_app_name}-alb-sg"
  description = "Allow inbound HTTP traffic to the Application Load Balancer"
  vpc_id      = aws_vpc.ecs.id

  ingress {
    description = "Allow HTTP from the internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.ecs_app_name}-alb-sg"
  }
}

resource "aws_lb" "ecs" {
  name               = "${local.ecs_app_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ecs_lb.id]
  subnets = [
    aws_subnet.ecs_public_a.id,
    aws_subnet.ecs_public_b.id
  ]

  tags = {
    Name = "${local.ecs_app_name}-alb"
  }
}

resource "aws_lb_target_group" "ecs" {
  name        = "${local.ecs_app_name}-tg"
  port        = var.ecs_container_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.ecs.id

  health_check {
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = "200"
  }
}

resource "aws_lb_listener" "ecs" {
  load_balancer_arn = aws_lb.ecs.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs.arn
  }
}

data "aws_iam_policy_document" "ecs_task_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "ecs_task_execution" {
  name               = "${local.ecs_app_name}-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_cloudwatch_log_group" "ecs" {
  name              = "/ecs/${local.ecs_app_name}"
  retention_in_days = 7
}

resource "aws_ecs_cluster" "ecs" {
  name = "${local.ecs_app_name}-cluster"
}

resource "aws_ecs_task_definition" "ecs" {
  family                   = local.ecs_app_name
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn

  container_definitions = jsonencode([
    {
      name      = "web"
      image     = var.ecs_task_image
      essential = true
      portMappings = [
        {
          containerPort = var.ecs_container_port
          hostPort      = var.ecs_container_port
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs.name
          awslogs-region        = var.AWS_DEFAULT_REGION
          awslogs-stream-prefix = "ecs"
        }
      }
      environment = [
        {
          name  = "MESSAGE"
          value = "Hello from LocalStack ECS"
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "ecs" {
  name             = "${local.ecs_app_name}-service"
  cluster          = aws_ecs_cluster.ecs.id
  task_definition  = aws_ecs_task_definition.ecs.arn
  desired_count    = var.ecs_desired_count
  launch_type      = "FARGATE"
  platform_version = "1.4.0"

  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200

  network_configuration {
    subnets = [
      aws_subnet.ecs_public_a.id,
      aws_subnet.ecs_public_b.id
    ]
    security_groups  = [aws_security_group.ecs_service.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs.arn
    container_name   = "web"
    container_port   = var.ecs_container_port
  }

  depends_on = [
    aws_lb_listener.ecs
  ]
}
