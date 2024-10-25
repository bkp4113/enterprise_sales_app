# ECS cluster
resource "aws_ecs_cluster" "enterprise_ms_cluster" {
  name = "enterprise-restapi-ms-cluster"
}

# Define task and service for each microservice (order_ms example)
resource "aws_ecs_task_definition" "order_ms_task" {
  family                   = "order-ms-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([{
    name      = "order-ms"
    image     = "${aws_ecr_repository.order_ms.repository_url}:latest"
    essential = true
    portMappings = [{
      containerPort = 80
      hostPort      = 80
    }]
    environment = [
      {
        name  = "ENVIRONMENT"
        value = var.environment
      }
    ]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = "/ecs/order-ms"
        "awslogs-region"        = data.aws_region.current.id
        "awslogs-stream-prefix" = "ecs"
      }
    }
  }])
}

resource "aws_ecs_service" "order_ms_service" {
  name            = "order-ms-service"
  cluster         = aws_ecs_cluster.ms_cluster.id
  task_definition = aws_ecs_task_definition.order_ms_task.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = aws_subnet.enterprise_public_subnet
    security_groups  = [aws_security_group.enterprise_sg_ecs.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.order_ms_tg.arn
    container_name   = "order-ms"
    container_port   = 80
  }
}
