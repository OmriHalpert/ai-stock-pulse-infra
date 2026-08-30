variable "cluster_name" {
  description = "EKS cluster name, used to prefix IAM resource names"
  type        = string
}

variable "oidc_provider_arn" {
  description = "ARN of the cluster OIDC provider"
  type        = string
}

variable "oidc_provider" {
  description = "OIDC issuer host without https:// (e.g. oidc.eks.eu-west-1.amazonaws.com/id/XXXX)"
  type        = string
}

variable "namespace" {
  description = "Namespace of the ESO controller ServiceAccount"
  type        = string
  default     = "external-secrets"
}

variable "service_account_name" {
  description = "Name of the ESO controller ServiceAccount"
  type        = string
  default     = "external-secrets"
}

variable "secret_arns" {
  description = "Secrets Manager ARNs ESO is allowed to read"
  type        = list(string)
}