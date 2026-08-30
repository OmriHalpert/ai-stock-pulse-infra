variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "project_name" {
  description = "Project name prefix"
  type        = string
  default     = "ai-stock-pulse"
}

variable "vpc_id" {
  description = "VPC ID where RDS will be deployed"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private Subnet IDs for the DB Subnet Group"
  type        = list(string)
}

variable "eks_nodes_security_group_id" {
  description = "Security Group ID of the EKS worker nodes allowed to connect"
  type        = string
}

variable "db_name" {
  description = "Name of the initial database"
  type        = string
  default     = "stock_pulse"
}

variable "db_username" {
  description = "Master database username"
  type        = string
  default     = "pulse"
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t4g.micro"
}

variable "allocated_storage" {
  description = "Allocated storage in GB"
  type        = number
  default     = 20
}