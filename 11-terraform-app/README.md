# Terraform + LocalStack Hands-on

Provision a Dockerised Flask API and a DynamoDB table in LocalStack using Terraform. The API exposes a simple `/items` endpoint that persists data to DynamoDB so you can verify read/write behaviour end-to-end.

## Learning goals

- Configure Terraform to use LocalStack as both an AWS emulator and a remote S3 backend.
- Build and launch a containerised application with the Terraform Docker provider.
- Validate that the app can create and read data from DynamoDB running inside LocalStack.

## Prerequisites

- Docker Desktop or Docker Engine 20.10+
- Terraform 1.5+ (`brew install terraform`, `asdf`, etc.)
- LocalStack CLI (`pip install localstack-cli`) or AWS CLI v2 for bootstrap commands
- Python is **not** required on the host – the Flask app runs in a container.

> Tip: On Linux, add `--add-host=host.docker.internal:host-gateway` when running containers that need to reach services exposed on the host.

## 1. Start LocalStack

Create an S3 bucket to host Terraform state and start LocalStack. Run these in a separate terminal window so LocalStack keeps running.

```bash
export AWS_ACCESS_KEY_ID=test
export AWS_SECRET_ACCESS_KEY=test
export AWS_DEFAULT_REGION=us-east-1

docker run --rm -it \
  -p 4566:4566 \
  -p 4510-4559:4510-4559 \
  --name localstack \
  localstack/localstack
```

Once LocalStack is up, bootstrap the backend bucket (use either `awslocal` or the AWS CLI):

```bash
awslocal s3 mb s3://terraform-localstack-state
# or
aws --endpoint-url=http://localhost:4566 s3 mb s3://terraform-localstack-state
```

## 2. Configure Terraform

This directory already contains the Terraform code. If you need to override defaults (for example, when `host.docker.internal` is not available), create a `terraform.tfvars` and adjust:

```hcl
localstack_edge_url = "http://172.17.0.1:4566"
app_host_port       = 8080
```

## 3. Deploy the stack

From `3-terraform-app/`:

```bash
terraform init
terraform apply
```

Terraform performs three tasks:

1. Creates a DynamoDB table in LocalStack.
2. Builds the Flask Docker image from `flask_app/`.
3. Runs the container and exposes it on the host (`http://localhost:5001` by default).

## 4. Test the application

Create an item:

```bash
curl -X POST http://localhost:5001/items \
  -H 'Content-Type: application/json' \
  -d '{"name":"terraform demo"}'
```

Fetch all items:

```bash
curl http://localhost:5001/items | jq
```

You can also inspect the data directly via the LocalStack CLI:

```bash
awslocal dynamodb scan --table-name terraform-training-items
```

## 5. Clean up

Destroy the resources and stop LocalStack when finished:

```bash
terraform destroy
docker stop localstack
```

## Troubleshooting

- **`terraform init` fails with backend errors** – confirm the `terraform-localstack-state` bucket exists and LocalStack is running.
- **Flask container cannot reach LocalStack** – set `localstack_edge_url` to an address reachable from inside the container (e.g. `http://172.17.0.1:4566` on Linux) and re-run `terraform apply`.
- **Port already in use** – adjust `app_host_port` in `terraform.tfvars`.

Happy Terraforming!
