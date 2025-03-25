output "secrets" {
  description = "Map of secret names to arns"
  value       = { for name, secret in aws_secretsmanager_secret.this : name => secret.arn }
}
