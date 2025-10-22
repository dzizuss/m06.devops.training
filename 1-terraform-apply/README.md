# Module 7 - Terraform Initialization

**Goal**: Initialize Terraform configuration to run on localstack

## Secrets

You will find a `localstack` secret in the organization. Use it in every job that uses the terraform command

## Steps

1. Examine the following files, try to guess what the function and purpose of each file is:
    - `main.tf`
    - `variables.tf`
    - `versions.tf`
2. Fork and add the project to Semaphore
3. Create the pipeline

Pipeline:

1. Initialize: run `terraform init` and cache the `.terraform` directory. You will need to restore it on the following jobs
2. Deploy: run `terraform validate` and `terraform apply -auto-approve` to create an S3 bucket
3. Use the bucket:

- run `alias aws="aws --endpoint-url=http://devops.tomfern.com:31566"`
- copy a file `aws s3 cp README.md s3://my-test-bucket/`
- list files `aws s3 ls s3://my-test-bucket`
- delete the file: `aws s3 rm s3://my-test-bucket/README.md`

4. **Destroy**: delete the bucket with `terrafor destoy`

2. Initialize Terraform: `terraform init`
3. Validate that the configuration is syntactically correct: `terraform validate`
4. Preview the Terraform plan: `terraform plan`
5. If everything looks good, execute the plan: `terraform apply`
6. What new files are directories are created? Which of these files should never be checked in the Git repository?
7. Alias aws to use the custom localstack endpoint: `alias aws="aws --endpoint-url=http://devops.tomfern.com:31566"`
7. A new S3 bucket should be running on localstack, you can check that it exists with: `aws --endpoint-url=http://localhost:4566 s3 ls`
8. Try copying a file into the bucket: `aws s3 cp README.md s3://my-test-bucket/`
9. To list the files in the S3 bucket use: `aws s3 ls s3://my-test-bucket`
10. Delete the file with: `aws s3 rm s3://my-test-bucket/README.md`
11. Destroy the S3 bucket using `terraform destroy -auto-approve`
