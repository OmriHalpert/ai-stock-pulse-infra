variable "cluster_name" {
  description = "EKS Cluster Name"
  type        = string
}

variable "cluster_endpoint" {
  description = "EKS Cluster Endpoint"
  type        = string
}

variable "cluster_ca_certificate" {
  description = "EKS Cluster CA Certificate"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where EKS is hosted"
  type        = string
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "eu-west-1"
}

variable "role_arn" {
  description = "IAM Role ARN for AWS Load Balancer Controller (IRSA)"
  type        = string
}

variable "certificate_arn" {
  description = "Foundation ACM certificate ARN for ALB/Ingress TLS"
  type        = string
}