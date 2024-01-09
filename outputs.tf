output "backend_public_id" {
    description = "The public ip address for the backend server"
    value       = aws_eip.terraform_backend_eip[0].public_ip
    depends_on  = [ aws_eip.terraform_backend_eip ]
}

output "backend_public_dns" {
    description = "The public dns address for the backend server"
    value       = aws_eip.terraform_backend_eip[0].public_dns
    depends_on  = [ aws_eip.terraform_backend_eip ]
}

output "frontend_public_id" {
    description = "The public ip address for the frontend server"
    value = aws_eip.terraform_frontend_eip[0].public_ip
    depends_on = [ aws_eip.terraform_frontend_eip ]
}

output "frontend_public_dns" {
    description = "The public dns address for the frontend server"
    value = aws_eip.terraform_frontend_eip[0].public_dns
    depends_on = [ aws_eip.terraform_frontend_eip ]
}

output "database_endpoint" {
    description = "Endpoint of the rds database"
    value = aws_db_instance.terraform_rds.address
}

output "port" {
    description = "port of the rds database"
    value = aws_db_instance.terraform_rds.port
}