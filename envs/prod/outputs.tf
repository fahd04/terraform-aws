output "frontend_public_ips" {
  description = "Public IPs of the frontend servers."
  value       = module.frontend.public_ips
}

output "frontend_instance_ids" {
  description = "Instance IDs of the frontend servers (for aws ssm start-session)."
  value       = module.frontend.instance_ids
}

output "backend_private_ips" {
  description = "Private IPs of the backend servers."
  value       = module.backend.private_ips
}

output "backend_instance_ids" {
  description = "Instance IDs of the backend servers (for aws ssm start-session)."
  value       = module.backend.instance_ids
}

output "database_endpoint" {
  description = "Hostname of the RDS database."
  value       = module.database.address
}

output "database_port" {
  description = "Port of the RDS database."
  value       = module.database.port
}

output "database_secret_arn" {
  description = "Secrets Manager ARN with the DB master credentials."
  value       = module.database.master_user_secret_arn
}
