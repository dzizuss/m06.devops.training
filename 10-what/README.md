# Terraform RDS on LocalStack

This exercise provisions a PostgreSQL RDS instance against the shared LocalStack endpoint, seeds it with sample data, and verifies the dataset with a simple query.

## Prerequisites

- Terraform ≥ 1.3
- AWS CLI (optional, useful for troubleshooting)
- PostgreSQL client (`psql`)
- LocalStack endpoint reachable at `http://devops.tomfern.com:31566`

## Configuration

Export the AWS-style credentials that LocalStack accepts:

```bash
export AWS_ACCESS_KEY_ID=test
export AWS_SECRET_ACCESS_KEY=test
export AWS_DEFAULT_REGION=us-east-1
```

Terraform variables can be overridden with a `terraform.tfvars` file or `-var` flags. Useful inputs include:

- `localstack_endpoint`
- `db_identifier`, `db_name`, `db_username`, `db_password`
- `allowed_cidr_blocks` if you want to restrict access

## Deploy the database

```bash
terraform init
terraform apply
```

Terraform exposes all connection details through outputs. The most important are `db_hostname`, `db_port`, `db_username`, `db_password`, and `db_name`.

## Seed the database

Run the helper script once the instance status is `available`:

```bash
./scripts/seed_db.sh
```

The script waits for the TCP endpoint, loads `sql/seed.sql`, and prints a confirmation message.

## Query the dataset

Use the query helper (or run your own SQL with `psql`):

```bash
./scripts/query_db.sh
```

Provide a custom SQL statement if you prefer:

```bash
./scripts/query_db.sh "SELECT COUNT(*) FROM orders;"
```

## Tear down

Destroy the resources when you finish the exercise:

```bash
terraform destroy
```

