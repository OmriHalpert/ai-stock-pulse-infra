output "role_arn" {
  description = "IAM role ARN for GitHub Actions (aws-actions/configure-aws-credentials)"
  value       = aws_iam_role.gha.arn
}