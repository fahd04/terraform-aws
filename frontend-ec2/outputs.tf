output "terraform_frontend_sg_id" {
  value = aws_security_group.terraform_frontend_sg.id
}

output "fontend_public_id" {
  value = aws_eip.terraform_frontend_eip[0].public_ip
}

output "fontend_public_dns" {
  value = aws_eip.terraform_frontend_eip[0].public_dns
}