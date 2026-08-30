output "cluster_name" {
  description = "EKS Cluster Name"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "EKS Control Plane Endpoint"
  value       = module.eks.cluster_endpoint
}

output "alb_controller_role_arn" {
  description = "IAM Role ARN for AWS Load Balancer Controller"
  value       = module.eks.alb_controller_role_arn
}

output "rds_endpoint" {
  description = "RDS Endpoint"
  value       = module.rds.db_instance_endpoint
}

output "rds_secret_arn" {
  description = "Secrets Manager Secret ARN for DB"
  value       = module.rds.db_secret_arn
}

output "hosted_zone_id" {
  description = "Foundation Route 53 hosted zone ID (looked up, not created)"
  value       = data.aws_route53_zone.primary.zone_id
}

output "acm_certificate_arn" {
  description = "Foundation ACM certificate ARN for Ingress annotations"
  value       = data.aws_acm_certificate.wildcard.arn
}

output "ecr_repository_urls" {
  description = "Foundation ECR repository URLs (looked up, not created)"
  value       = { for k, v in data.aws_ecr_repository.repos : k => v.repository_url }
}

output "eso_role_arn" {
  description = "IAM role ARN for External Secrets Operator (IRSA)"
  value       = module.eso.role_arn
}

output "external_dns_role_arn" {
  description = "IAM role ARN for ExternalDNS (IRSA)"
  value       = module.external_dns.role_arn
}
