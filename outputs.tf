output "backend_public_id" {
    description = "The public ip address for the backend server"
    value       = module.backend-ec2.backend_public_id
    depends_on  = [ module.backend-ec2 ]
}

output "backend_public_dns" {
    description = "The public dns address for the backend server"
    value       = module.backend-ec2.backend_public_dns
    depends_on  = [ module.backend-ec2 ]
}

output "frontend_public_id" {
    description = "The public ip address for the frontend server"
    value = module.frontend-ec2.fontend_public_id
    depends_on = [ module.frontend-ec2 ]
}

output "frontend_public_dns" {
    description = "The public dns address for the frontend server"
    value = module.frontend-ec2.fontend_public_dns
    depends_on = [ module.frontend-ec2 ]
}

output "database_endpoint" {
    description = "Endpoint of the rds database"
    value = module.mysql-rds.database_endpoint
    depends_on = [ module.mysql-rds ]
}

output "port" {
    description = "port of the rds database"
    value = module.mysql-rds.port
    depends_on = [ module.mysql-rds ]
}