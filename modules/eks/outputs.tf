output "cluster_name" {
  description = "Name of the EKS cluster"
  value       = aws_eks_cluster.main.name
}

output "cluster_endpoint" {
  description = "Endpoint for your Kubernetes API server"
  value       = aws_eks_cluster.main.endpoint
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = aws_eks_cluster.main.certificate_authority[0].data
}

output "cluster_arn" {
  description = "ARN of the EKS cluster"
  value       = aws_eks_cluster.main.arn
}

output "node_role_arn" {
  description = "ARN of the worker node IAM role"
  value       = aws_iam_role.nodes.arn
}

output "oidc_provider_arn" {
  description = "ARN of the cluster OIDC provider"
  value       = aws_iam_openid_connect_provider.eks.arn
}

output "oidc_provider" {
  description = "Issuer URL of the cluster OIDC provider without https://"
  value       = replace(aws_eks_cluster.main.identity[0].oidc[0].issuer, "https://", "")
}

output "alb_controller_role_arn" {
  description = "IAM Role ARN for AWS Load Balancer Controller"
  value       = aws_iam_role.alb_controller.arn
}

output "node_security_group_id" {
  description = "Security group ID attached to the EKS cluster/nodes"
  value       = aws_eks_cluster.main.vpc_config[0].cluster_security_group_id
}