# Module 6 - Terraform and AWS

**Goal**: Initialize Terraform configuration to run on localstack

## Secrets

You will find a `localstack` secret in the organization. Use it in all jobs.

## Preparation

Each team will have to select a unique name for their S3 bucket. Open the `variables.tf`, update the bucket name and push the file to the repository.

## Steps

1. Examine the following files, try to guess what the function and purpose of each file is:
    - `main.tf`
    - `variables.tf`
    - `versions.tf`
2. Fork and add the project to Semaphore
3. Create the pipeline

Pipeline:

1. Initialize: run `terraform init` then store the following files in the artifact store:

- `.terraform`
- `.terraform.lock.hcl`

2. Deploy:

- Pull from artifacts `.terraform` and `.terraform.lock.hcl`
- Run `terraform validate` and `terraform apply -auto-approve` to create an S3 bucket.
- Store the file `terraform.tfstate` as artifact

3. Use the bucket:

- run `alias aws="aws --endpoint-url=http://devops.tomfern.com:31566"`
- copy a file `aws s3 cp README.md s3://my-test-bucket/`
- list files `aws s3 ls s3://my-test-bucket`
- delete the file: `aws s3 rm s3://my-test-bucket/README.md`

4. **Destroy**:

- pull all files in the artifact store
- delete the bucket with `terraform destoy -auto-approve` (the bucket must be empty)

Examine the job logs to confirm terraform worked without errors.
