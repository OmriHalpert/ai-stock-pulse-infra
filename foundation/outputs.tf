output "zone_id" {
  description = "Route 53 public hosted zone ID"
  value       = module.dns.zone_id
}

output "name_servers" {
  description = "Route 53 name servers to configure at the registrar"
  value       = module.dns.name_servers
}

output "certificate_arn" {
  description = "ARN of the validated wildcard ACM certificate"
  value       = module.dns.certificate_arn
}

output "ecr_repository_urls" {
  description = "Map of ECR repository names to URLs"
  value       = module.ecr.repository_urls
}

output "ecr_repository_arns" {
  description = "Map of ECR repository names to ARNs"
  value       = module.ecr.repository_arns
}

output "gha_ecr_role_arn" {
  description = "IAM role for GitHub Actions to push to ECR"
  value       = module.gha_ecr.role_arn
}

output "argocd_github_pat_secret_name" {
  description = "Secrets Manager secret name holding the Argo CD GitHub PAT"
  value       = aws_secretsmanager_secret.argocd_github_pat.name
}
