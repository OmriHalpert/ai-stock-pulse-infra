variable "name_prefix" {
  description = "Prefix for IAM resources"
  type        = string
  default     = "ai-stock-pulse"
}

variable "github_org" {
  description = "GitHub org or user that owns the app repo"
  type        = string
  default     = "ai-stock-pulse-services"
}

variable "github_repo" {
  description = "App repository name"
  type        = string
  default     = "ai-stock-pulse"
}

variable "ecr_repository_arns" {
  description = "ECR repository ARNs GitHub Actions may push to"
  type        = list(string)
}

variable "github_owner_id" {
  description = "Numeric GitHub owner ID used in the immutable OIDC sub claim"
  type        = string
}
variable "github_repo_id" {
  description = "Numeric GitHub repo ID used in the immutable OIDC sub claim"
  type        = string
}