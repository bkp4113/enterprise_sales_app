# IAM Role for Lambda Function
resource "aws_iam_role" "enterprise_order_service_role" {
  name = "lambda-dynamodb-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action    = "sts:AssumeRole",
        Effect    = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# IAM Policy for Lambda to access DynamoDB and Streams
resource "aws_iam_policy" "enterprise_lambda_dynamodb_policy" {
  name        = "enterprise-lambda-dynamodb-policy"
  description = "Policy allowing Lambda to access DynamoDB table and stream."

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:Query",
          "dynamodb:DescribeStream",
          "dynamodb:GetRecords",
          "dynamodb:GetShardIterator",
          "dynamodb:ListStreams"
        ],
        Resource = "${aws_dynamodb_table.enterprise_order.arn}"
      },
      {
        Effect   = "Allow",
        Action   = [
          "dynamodb:DescribeStream",
          "dynamodb:GetRecords",
          "dynamodb:GetShardIterator",
          "dynamodb:ListStreams"
        ],
        Resource = "${aws_dynamodb_table.enterprise_order.stream_arn}"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_dynamodb_attachment" {
  role       = aws_iam_role.enterprise_order_service_role.name
  policy_arn = aws_iam_policy.enterprise_lambda_dynamodb_policy.arn
}

# ECS Execution Role
resource "aws_iam_role" "ecs_execution_role" {
  name = "apiexecutionrole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach policy to allow ECS tasks to pull images and write logs
resource "aws_iam_policy" "ecs_execution_policy" {
  name        = "ECSExecutionPolicy"
  description = "Policy for ECS execution role to access specific ECR and CloudWatch log resources"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:GetAuthorizationToken"
        ],
        Resource = "arn:aws:ecr:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:repository/*-ms"
      },
      {
        Effect   = "Allow",
        Action   = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/ecs/*-ms:*"
      }
    ]
  })
}

# Attach the policy to the execution role
resource "aws_iam_role_policy_attachment" "ecs_execution_policy_attachment" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = aws_iam_policy.ecs_execution_policy.arn
}

# ECS Task Role
resource "aws_iam_role" "order_ms_ecs_task_role" {
  name = "order_ms_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# DynamoDB CRUD Policy for Order Table only
resource "aws_iam_policy" "order_ms_ecs_task_crud_access" {
  name        = "DynamoDBCrudAccess"
  description = "Policy to allow ECS task to perform CRUD operations on the Order DynamoDB table"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "dynamodb:BatchGetItem",
          "dynamodb:BatchWriteItem",
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:DeleteItem",
          "dynamodb:UpdateItem",
          "dynamodb:Query",
          "dynamodb:DescribeTable",
        ],
        Resource = [
            "${aws_dynamodb_table.enterprise_order.arn}"
        ]
      }
    ]
  })
}

# Cognito Access Policy
resource "aws_iam_policy" "order_ms_ecs_task_cognito_access" {
  name        = "CognitoAccess"
  description = "Policy to allow ECS task to access Cognito"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "cognito-idp:*" # This can be limited to get user or depending on application needs
        ],
        Resource = var.cognito_user_pool_arn
      }
    ]
  })
}

# Attach policies to the ECS task role
resource "aws_iam_role_policy_attachment" "task_order_ms_dynamodb_attachment" {
  role       = aws_iam_role.order_ms_ecs_task_role.name
  policy_arn = aws_iam_policy.order_ms_ecs_task_crud_access.arn
}

resource "aws_iam_role_policy_attachment" "task_order_ms_cognito_attachment" {
  role       = aws_iam_role.order_ms_ecs_task_role.name
  policy_arn = aws_iam_policy.order_ms_ecs_task_cognito_access.arn
}
