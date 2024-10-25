terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.0"
    }
  }
}

terraform {
  backend "http" {
  }
}

provider "aws" {
  profile = "enterprise-dev"
  region  = "us-east-2"
  default_tags {
    tags = {
      Project = "Enterprise"
      Environment = "Development"
      ManagedWith = "Terraform"
    }
  }
}
