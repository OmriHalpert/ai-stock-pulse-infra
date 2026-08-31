variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "manifests_repo_url" {
  description = "Git URL Argo CD clones for Application manifests"
  type        = string
}

variable "github_pat" {
  description = "GitHub PAT with read access to the manifests repo"
  type        = string
  sensitive   = true
}