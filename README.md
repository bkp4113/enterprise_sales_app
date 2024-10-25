# Project Notes
- Usually each ms repo shall have been it's on version controlled repo for easier management but for assignment purpose, I am encapsulating them here.
- Each ms repo shall have it's own CICD pipeline as following for MR and Release flow (Additionally docker sec. pipeline can be implemented to achieve security testing of Docker images)
  - Lint(Ruff or similar) ?pass -> Test (Run Python Unittest) ?pass -> Build ?pass -> Deploy (ECR & Kick off ops pipeline for TF deployment)
- Each service repo shall have it's own CICD pipeline as following for MR and Release flow (Additionally docker sec. pipeline can be implemented to achieve security testing of Docker images)
  - Lint(Ruff or similar) ?pass -> Validate (CFN Lint) ?Pass -> Test (Run Python Unittest) ?pass -> Build ?pass -> Deploy(SAM or CF or Terraform)
- Upon, reviewing the requirement closely, I have elected to use the DynamoDB(Stream) rather than Kafka as it scalable and cost effective solution. Where for MSK Serverless you't pay for the cluster but would for the data processed and on the other end of the subscriber side of order processing would require a persistent app on ECS cluster which can poll messages from kafka topics and process it. So during the downtime, you'd be paying for the minimum vs serverless DynamoDB you'd only pay for stream + lambda usage.
  - MSK(Serverless) Notes
    - We could also use the MSK UI from Provectous labs(Opensource)
      - https://docs.kafka-ui.provectus.io/quick-start/prerequisites/permissions/msk-+serverless-setup
    - Features: https://docs.kafka-ui.provectus.io/overview/features
- Terraform State Management
  - Mostly to be done via the Gitlab or Git

## Pre requirements
Install terraform on local system via brew
- `brew install terraform`

Setup TF state management locally or via the Gitlab or Git
```bash
export TF_STATE_NAME='enterpise-sales-app-dev'

terraform init \
    -backend-config="address=<giturl>/$TF_STATE_NAME" \
    -backend-config="lock_address=<giturl>/$TF_STATE_NAME/lock" \
    -backend-config="unlock_address=<giturl>/$TF_STATE_NAME/lock" \
    -backend-config="username=<gitusername>" \
    -backend-config="password=<gittoken>" \
    -backend-config="lock_method=POST" \
    -backend-config="unlock_method=DELETE" \
    -backend-config="retry_wait_min=5

```
Since there are no import requirement, we are fine otherwise import the required resources for the managed state from Gitlab or Git

## Terraform Guide
To manage the tf files.
- Update the TF IAC code
- For the fist time run `terraform init` see above in pre requirements
- Run `terraform fmt <filename>.tf`
- Run `terraform plan -out .plan/change` to confirm the changes
- Run `terrafrom apply '.plan/change'`

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

## TODO:
- Re-organize the TF repo for modular compatibility
- Lint TF & Python code
- Fix order reference in other microservice other than order_ms as it's built from order_ms skeleton.
- Build authorization in microservices
- Create other ecs task
- Introduce ASG
- Terraform deployment validation