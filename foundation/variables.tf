variable "aws_region" {
  description = "AWS region for foundation resources (ACM must be in the same region as the ALB)"
  type        = string
  default     = "eu-west-1"
}

variable "environment" {
  description = "Tag for persistent foundation assets"
  type        = string
  default     = "foundation"
}

variable "domain_name" {
  description = "Root domain name for the public hosted zone and ACM certificate"
  type        = string
  default     = "ai-stuck-pulse.xyz"
}

variable "repository_names" {
  description = "ECR repositories owned by the foundation layer"
  type        = list(string)
  default = [
    "ai-stock-pulse/backend",
    "ai-stock-pulse/frontend",
    "ai-stock-pulse/agent",
  ]
}
