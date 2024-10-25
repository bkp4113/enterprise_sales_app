variable "place_holder_var" {
  description = "Place holder var allowing you to preserver the vars in TF state and be prompted and used for TF deployment or resource customisation"
  type        = string
}

variable "log_level" {
  description = "Application log level"
  type        = string
  default     = "INFO"
}

variable "cpu" {
  description = "ECS Task CPU"
  type        = string
  default     = "0.5"
}

variable "memory" {
  description = "ECS Task Memory"
  type        = string
  default     = "1024"
}

variable "environment" {
  description = "Environment"
  type        = string
  default     = "dev"
}

variable "desired_count" {
  type        = "type"
  description = "Desired count"
  default     = "1"
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnets in the VPC"
  type        = list(string)
}

variable "private_subnets" {
  description = "List of private subnets in the VPC"
  type        = list(string)
}

variable "cognito_user_pool_arn" {
  description = "Cognito user pool arn"
  type        = string
}