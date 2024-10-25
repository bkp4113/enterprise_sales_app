# Build Docker image and push it to ECR for each service
resource "null_resource" "order_ms_build" {
  provisioner "local-exec" {
    command = <<EOT
      aws ecr get-login-password --region ${data.aws_region.current.id} | docker login --username AWS --password-stdin ${aws_ecr_repository.order_ms.repository_url}
      docker build -t ${aws_ecr_repository.enterprise_sales_app_order_ms_repo.repository_url}:latest ../../order_ms
      docker push ${aws_ecr_repository.enterprise_sales_app_order_ms_repo.repository_url}:latest
    EOT
  }
}

resource "null_resource" "inventory_ms_build" {
  provisioner "local-exec" {
    command = <<EOT
      aws ecr get-login-password --region ${data.aws_region.current.id} | docker login --username AWS --password-stdin ${aws_ecr_repository.inventory_ms.repository_url}
      docker build -t ${aws_ecr_repository.enterprise_sales_app_inventory_ms_repo.repository_url}:latest ../../inventory_ms
      docker push ${aws_ecr_repository.enterprise_sales_app_inventory_ms_repo.repository_url}:latest
    EOT
  }
}

resource "null_resource" "product_ms_build" {
  provisioner "local-exec" {
    command = <<EOT
      aws ecr get-login-password --region ${data.aws_region.current.id} | docker login --username AWS --password-stdin ${aws_ecr_repository.product_ms.repository_url}
      docker build -t ${aws_ecr_repository.enterprise_sales_app_product_ms_repo.repository_url}:latest ../../product_ms
      docker push ${aws_ecr_repository.enterprise_sales_app_product_ms_repo.repository_url}:latest
    EOT
  }
}

resource "null_resource" "user_ms_build" {
  provisioner "local-exec" {
    command = <<EOT
      aws ecr get-login-password --region ${data.aws_region.current.id} | docker login --username AWS --password-stdin ${aws_ecr_repository.user_ms.repository_url}
      docker build -t ${aws_ecr_repository.enterprise_sales_app_user_ms_repo.repository_url}:latest ../../user_ms
      docker push ${aws_ecr_repository.enterprise_sales_app_user_ms_repo.repository_url}:latest
    EOT
  }
}

resource "null_resource" "order_service_build" {
  provisioner "local-exec" {
    command = <<EOT
      aws ecr get-login-password --region ${data.aws_region.current.id} | docker login --username AWS --password-stdin ${aws_ecr_repository.user_ms.repository_url}
      docker build -t ${aws_ecr_repository.enterprise_sales_app_order_service.repository_url}:latest ../../order_service
      docker push ${aws_ecr_repository.enterprise_sales_app_order_service.repository_url}:latest
    EOT
  }
}
