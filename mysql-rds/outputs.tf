output "database_endpoint" {
  value = aws_db_instance.terraform_rds.address
}

output "port" {
  value = aws_db_instance.terraform_rds.port
}