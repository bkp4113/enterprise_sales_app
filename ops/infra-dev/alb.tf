
# ALB
resource "aws_lb" "enterprise_alb" {
  name            = "enterprise-restapi-alb"
  internal        = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.enterprise_sg_alb.id]
  subnets         = var.public_subnets
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.enterprise_alb.dns_name
}

# Target group for ECS service
resource "aws_lb_target_group" "order_ms_tg" {
  name     = "order-ms-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/v1/health/"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

# ALB Listener
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.enterprise_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.order_ms_tg.arn
  }
}


# TODO: Add other microservices