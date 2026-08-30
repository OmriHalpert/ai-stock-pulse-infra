variable "vpc_cidr" {
  type        = string
  description = "The overarching IP address range (CIDR) for the entire VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for public subnets (where ALBs and NAT live)"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for private subnets (where EKS worker nodes live)"
  default     = ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "availability_zones" {
  type        = list(string)
  description = "List of Availability Zones in eu-west-1 to deploy subnets across for High Availability"
  default     = ["eu-west-1a", "eu-west-1b"]
}

variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster, used to prefix resource names and add auto-discovery tags"
  default     = "ai-stock-pulse-dev"
}