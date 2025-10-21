# Module 7 - Terraform CI/CD

**Goal**: Run Terraform in Semaphore

## Steps

1. Create a pipeline with two blocks:

- Block one validates and initializes Terraform
- Block two runs localstack and applies the Terraform plan. In block two, override the agent to use s1-ubuntu instead of the default.
- Use the terraform files located in this directory

2. Use the following commands in order to run localstack in CI:

- wget <https://github.com/localstack/localstack-cli/releases/download/v4.3.0/localstack-cli-4.3.0-linux-amd64.tar.gz>
- tar xvzf localstack-cli-4.3.0-linux-amd64.tar.gz
- localstack/localstack  start -d

3. You must define the following environment variables in the apply block:

- AWS_ACCESS_KEY_ID=test
- AWS_SECRET_ACCESS_KEY=test

4. Run the following command to test the S3 bucket is accessible: `aws --endpoint-url=http://localhost:4566 s3 ls`

## Tips

- Check the supplied pipeline.png file as an example
- You can find one solution in the `solution` branch in the repository
- Consider how different is running localhost in your machine vs the CI environment
