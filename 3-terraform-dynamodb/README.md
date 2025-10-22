# Module 6 - Deploy a DynamoDB Table

**Goal**: Manage a local DynamoDB table running on LocalStack.

## Secrets

You will find a `localstack` secret in the organization. Use it in all jobs.

## Preparation

Each team must use a unique table name. Open `variables.tf`, update `table_name`, and push the change to the repository.

## Steps

1. Examine the following files and identify the role of each:
   - `main.tf`
   - `variables.tf`
   - `versions.tf`
2. Fork and add the project to Semaphore.
3. Create the pipeline.

Add the following blocks, they should depend on the first block (initialization) created in the previous exercise

2. Deploy:

- run `terraform validate` followed by `terraform apply -auto-approve` to create the DynamoDB table.
- Artifact store `terraform.tfstate`.

3. Interact with the table:
   - run `alias aws="aws --endpoint-url=http://devops.tomfern.com:31566"`
   - list tables with `aws dynamodb list-tables`
   - describe the table with `aws dynamodb describe-table --table-name <your-table-name>`
   - insert a record:
      `aws dynamodb put-item \
        --table-name devops-training-table \
        --item '{
            "user_id": {"S": "u1"},
            "name": {"S": "Alice"},
            "email": {"S": "alice@example.com"}
          }'`
    - list table contents: `aws dynamodb scan --table-name devops-training-table`
4. **Destroy**: delete the table with `terraform destroy -auto-approve`. You must first restore all files from the artifact store.

Review the job logs to confirm Terraform managed the DynamoDB table without errors.
