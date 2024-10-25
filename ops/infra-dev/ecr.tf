resource "aws_ecr_repository" "enterprise_sales_app_order_ms_repo" {
    name                 = "enterprise_sales_app_order_ms_repo"
    image_tag_mutability = "MUTABLE"

    image_scanning_configuration {
        scan_on_push = true
    }
}


data "aws_iam_policy_document" "ecr_policy" {
    statement {
        sid    = "ecr policy"
        effect = "Allow"

        principals {
            type        = "AWS"
            identifiers = [data.aws_caller_identity.current.account_id]
        }

        actions = [
            "ecr:GetDownloadUrlForLayer",
            "ecr:BatchGetImage",
            "ecr:BatchCheckLayerAvailability",
            "ecr:PutImage",
            "ecr:InitiateLayerUpload",
            "ecr:UploadLayerPart",
            "ecr:CompleteLayerUpload",
            "ecr:DescribeRepositories",
            "ecr:GetRepositoryPolicy",
            "ecr:ListImages",
            "ecr:SetRepositoryPolicy",
        ]
    }
}

resource "aws_ecr_repository_policy" "ecr_repo_policy" {
    repository = aws_ecr_repository.enterprise_sales_app_order_ms_repo.name
    policy     = data.aws_iam_policy_document.enterprise_sales_app_order_ms_repo.json
}

# Cleanup image older than x days
resource "aws_ecr_lifecycle_policy" "enterprise_policy_lifecycle" {
    repository = aws_ecr_repository.enterprise_sales_app_order_ms_repo.name

    policy = <<EOF
    {
        "rules": [
            {
                "rulePriority": 1,
                "description": "Expire images older than 365 days",
                "selection": {
                    "tagStatus": "untagged",
                    "countType": "sinceImagePushed",
                    "countUnit": "days",
                    "countNumber": 365
                },
                "action": {
                    "type": "expire"
                }
            }
        ]
    }
    EOF
    }

# TODO: Other ECR repos can be setup just like above
resource "aws_ecr_repository" "enterprise_sales_app_product_ms_repo" {
    name                 = "enterprise_sales_app_product_ms_repo"
    image_tag_mutability = "MUTABLE"

    image_scanning_configuration {
        scan_on_push = true
    }
}

resource "aws_ecr_repository" "enterprise_sales_app_user_ms_repo" {
    name                 = "enterprise_sales_app_user_ms_repo"
    image_tag_mutability = "MUTABLE"

    image_scanning_configuration {
        scan_on_push = true
    }
}

resource "aws_ecr_repository" "enterprise_sales_app_inventory_ms_repo" {
    name                 = "enterprise_sales_app_inventory_ms_repo"
    image_tag_mutability = "MUTABLE"

    image_scanning_configuration {
        scan_on_push = true
    }
}

resource "aws_ecr_repository" "enterprise_sales_app_order_service" {
    name                 = "enterprise_sales_app_order_service"
    image_tag_mutability = "MUTABLE"

    image_scanning_configuration {
        scan_on_push = true
    }
}
