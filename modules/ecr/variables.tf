variable "repository_names" {
  description = "List of ECR repository names to create"
  type        = list(string)
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "image_tag_mutability" {
  description = "The tag mutability setting for the repository"
  type        = string
  default     = "MUTABLE"
}

variable "force_delete" {
  description = "Whether to delete the repository even if it contains images"
  type        = bool
  default     = false
}

variable "max_image_count" {
  description = "Number of tagged images to keep"
  type        = number
  default     = 10
}