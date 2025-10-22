# Module 6 - Terraform VMs

**Goal**: Create an EC2 instance

## Secrets

You will find a `localstack` secret in the organization. Use it in all jobs.

## Preparation

Each team will have to select a unique name for their VM bucket. Open the `variables.tf`, update the bucket name and push the file to the repository.

## Steps

1. Examine the following files, try to guess what the function and purpose of each file is:
    - `main.tf`
    - `variables.tf`
    - `versions.tf`

Add the following blocks, they should depend on the first block (initialization) created in the previous exercise

2. Deploy:

- Pull from artifacts `.terraform` and `.terraform.lock.hcl`
- Run `terraform validate` and `terraform apply -auto-approve` to create an EC2 instance.
- Store the file `terraform.tfstate` as artifact
- Check the job logs to see the machine IP and DNS

4. **Destroy**:

- pull all files in the artifact store
- delete the bucket with `terraform destoy -auto-approve`

Examine the job logs to confirm terraform worked without errors.
