output "zone_id" {
  description = "The ID of the Route 53 Hosted Zone"
  value       = aws_route53_zone.main.zone_id
}

output "name_servers" {
  description = "The Route 53 name servers for registrar delegation"
  value       = aws_route53_zone.main.name_servers
}

output "certificate_arn" {
  description = "The ARN of the validated ACM TLS Certificate"
  value       = aws_acm_certificate_validation.cert.certificate_arn
}
