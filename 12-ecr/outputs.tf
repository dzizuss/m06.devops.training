output "repository_name" {
  value = aws_ecr_repository.app_repo.name
}

output "repository_url_localstack_magic" {
  value = "000000000000.dkr.ecr.localhost.localstack.cloud:4566/${aws_ecr_repository.app_repo.name}"
}

output "repository_url_plain_localhost" {
  value = "localhost:4566/${aws_ecr_repository.app_repo.name}"
}

