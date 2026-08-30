output "db_instance_endpoint" {
  description = "Connection endpoint for the RDS instance"
  value       = aws_db_instance.main.endpoint
}

output "db_instance_address" {
  description = "Address (hostname) of the RDS instance"
  value       = aws_db_instance.main.address
}

output "db_security_group_id" {
  description = "Security Group ID of the RDS instance"
  value       = aws_security_group.rds.id
}

output "db_secret_arn" {
  description = "ARN of the Secrets Manager secret containing database credentials"
  value       = aws_secretsmanager_secret.db_credentials.arn
}