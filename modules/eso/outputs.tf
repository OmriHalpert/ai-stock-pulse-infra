output "role_arn" {
  description = "IAM role ARN to annotate on the ESO ServiceAccount"
  value       = aws_iam_role.this.arn
}