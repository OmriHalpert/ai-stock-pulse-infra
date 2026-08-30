variable "aws_region" {
  description = "AWS region for the ephemeral dev stack"
  type        = string
  default     = "eu-west-1"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "ai-stock-pulse-dev"
}

variable "domain_name" {
  description = "Root domain used to look up the foundation hosted zone and ACM certificate"
  type        = string
  default     = "ai-stuck-pulse.xyz"
}

variable "repository_names" {
  description = "Foundation ECR repository names to look up"
  type        = list(string)
  default = [
    "ai-stock-pulse/backend",
    "ai-stock-pulse/frontend",
    "ai-stock-pulse/agent"
  ]
}

variable "alb_controller_role_arn" {
  description = "IRSA role ARN for AWS Load Balancer Controller"
  type        = string
  default     = "arn:aws:iam::661985535801:role/ai-stock-pulse-dev-aws-load-balancer-controller"
}

