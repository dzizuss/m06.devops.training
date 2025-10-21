# Module 7 - Terraform

**Goal**: Start a localstack environment to test Terraform commands

## Steps

1. Pull the localstack image: `docker pull localstack/localstack`
2. Start the localstack containers: `docker run -d -p 4566:4566 -p 4571:4571 --name localstack_container localstack/localstack`
3. Verify that localstack is running: `docker logs localstack_container`
