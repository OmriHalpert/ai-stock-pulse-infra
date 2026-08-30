variable "cluster_name" {
  description = "EKS cluster name, used to prefix IAM resource names"
  type        = string
}

variable "oidc_provider_arn" {
  description = "ARN of the cluster OIDC provider"
  type        = string
}

variable "oidc_provider" {
  description = "OIDC issuer host without https://"
  type        = string
}

variable "route53_zone_id" {
  description = "Hosted zone ID ExternalDNS is allowed to manage"
  type        = string
}

variable "namespace" {
  description = "Namespace of the ExternalDNS ServiceAccount"
  type        = string
  default     = "external-dns"
}

variable "service_account_name" {
  description = "Name of the ExternalDNS ServiceAccount"
  type        = string
  default     = "external-dns"
}