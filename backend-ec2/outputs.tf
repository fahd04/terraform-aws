output "terraform_backend_sg_id" {
  value = aws_security_group.terraform_backend_sg.id
}

output "backend_public_id" {
  value = aws_eip.terraform_backend_eip[0].public_ip
}

output "backend_public_dns" {
  value = aws_eip.terraform_backend_eip[0].public_dns
}