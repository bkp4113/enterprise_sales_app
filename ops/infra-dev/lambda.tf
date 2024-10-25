# Lambda Function
resource "aws_lambda_function" "enterprise_order_poller_service" {
  function_name = "Enterprise-OrderPoller"
  role          = aws_iam_role.enterprise_order_service_role.arn
  handler       = "order_poller.lambda_handler"
  runtime       = "python3.12"

  image_uri = "${aws_ecr_repository.enterprise_sales_app_order_service.repository_url}:latest" 

  environment {
    variables = {
      LOG_LEVEL       = var.log_level
    }
  }

  depends_on = [aws_iam_role_policy_attachment.lambda_dynamodb_attachment]
}

# Event source mapping for DynamoDB stream to Lambda
resource "aws_lambda_event_source_mapping" "enterprise_order_poller_service_trigger" {
  event_source_arn = aws_dynamodb_table.enterprise_order.stream_arn
  function_name    = aws_lambda_function.enterprise_order_poller_service.arn
  starting_position = "LATEST"
  batch_size        = 100
}

resource "aws_lambda_function" "enterprise_order_processor_service" {
  function_name = "Enterprise-OrderPoller"
  role          = aws_iam_role.enterprise_order_service_role.arn
  handler       = "order_poller.lambda_handler"
  runtime       = "python3.12"

  image_uri = "${aws_ecr_repository.enterprise_sales_app_order_service.repository_url}:latest" 

  environment {
    variables = {
      LOG_LEVEL       = var.log_level
    }
  }

  depends_on = [aws_iam_role_policy_attachment.lambda_dynamodb_attachment]
}