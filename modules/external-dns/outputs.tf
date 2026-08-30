output "role_arn" {
  description = "IAM role ARN to annotate on the ExternalDNS ServiceAccount"
  value       = aws_iam_role.this.arn
}