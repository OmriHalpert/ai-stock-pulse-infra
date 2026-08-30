variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster"
  default     = "ai-stock-pulse-dev"
}

variable "cluster_version" {
  type        = string
  description = "Kubernetes control plane version"
  default     = "1.32"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where the EKS cluster will be deployed"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private Subnet IDs for worker nodes and pods"
}

variable "node_instance_types" {
  type        = list(string)
  description = "EC2 instance types for the managed node group"
  default     = ["t3.medium"]
}

variable "desired_size" {
  type        = number
  description = "Desired number of worker nodes"
  default     = 2
}

variable "min_size" {
  type        = number
  description = "Minimum number of worker nodes"
  default     = 1
}

variable "max_size" {
  type        = number
  description = "Maximum number of worker nodes"
  default     = 3
}