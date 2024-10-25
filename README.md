# Project Notes

- Each microservice (MS) repository would ideally have its own version-controlled repo for better management. However, for assignment purposes, they are encapsulated here.
- Each MS repo should have its own CI/CD pipeline configured for Merge Request (MR) and Release flows. Additionally, a Docker security pipeline can be implemented for Docker image security testing.
  - **Pipeline Steps**: Lint (Ruff or similar) ➔ Test (Run Python Unittest) ➔ Build ➔ Deploy (Push to ECR & trigger ops pipeline for Terraform deployment).
- Each service repo should also have a CI/CD pipeline for MR and Release flows, with optional Docker security testing.
  - **Pipeline Steps**: Lint (Ruff or similar) ➔ Validate (CFN Lint) ➔ Test (Run Python Unittest) ➔ Build ➔ Deploy (via SAM, CloudFormation, or Terraform).

- **DynamoDB vs. Kafka**: After reviewing requirements, DynamoDB Streams were chosen over Kafka for scalability and cost-effectiveness. MSK Serverless requires paying for a cluster and a persistent app on an ECS cluster to poll and process Kafka topics. DynamoDB Streams, however, is fully serverless, with costs only for stream and Lambda usage.
  - **MSK (Serverless) Notes**:
    - **MSK UI**: [Provectus Labs MSK UI](https://docs.kafka-ui.provectus.io/quick-start/prerequisites/permissions/msk-+serverless-setup) (Open-source)
    - **Features**: See [Provectus documentation](https://docs.kafka-ui.provectus.io/overview/features).

- **Terraform State Management**: Use GitLab or Git to manage the Terraform state.

---

## Pre-Requirements

Install Terraform on your local system:
```bash
brew install terraform
```

Set up Terraform (TF) state management locally or via GitLab/Git:
```bash
export TF_STATE_NAME='enterprise-sales-app-dev'

terraform init \
    -backend-config="address=<giturl>/$TF_STATE_NAME" \
    -backend-config="lock_address=<giturl>/$TF_STATE_NAME/lock" \
    -backend-config="unlock_address=<giturl>/$TF_STATE_NAME/lock" \
    -backend-config="username=<gitusername>" \
    -backend-config="password=<gittoken>" \
    -backend-config="lock_method=POST" \
    -backend-config="unlock_method=DELETE" \
    -backend-config="retry_wait_min=5"
```

Since no imports are required, initialization should suffice. Otherwise, import necessary resources for managed state from GitLab/Git.

---

## Terraform Guide

To manage the Terraform files:

1. Update the Terraform IAC code.
2. Run `terraform init` (see pre-requirements above).
3. Run `terraform fmt <filename>.tf`.
4. Run `terraform plan -out .plan/change` to confirm changes.
5. Run `terraform apply '.plan/change'` to deploy.

---

# AWS Services Managed via Terraform IAC

- Cognito
- ECR
- ECS
- VPC
- DynamoDB
- MSK
- ALB
- CloudFront
- Lambda
- IAM

---

## TODO

- Re-organize the Terraform repo for modular compatibility.
- Implement linting for both Terraform and Python code.
- Correct order references in microservices other than `order_ms`, which is based on the `order_ms` skeleton.
- Build authorization for microservices.
- Create additional ECS tasks.
- Introduce Auto Scaling Group (ASG).
- Validate Terraform deployment.
