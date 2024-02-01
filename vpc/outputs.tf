output "vpc_id" {
  value = aws_vpc.terraform_vpc.id
}

output "terraform_private_subnet" {
  value = aws_subnet.terraform_private_subnet
}

output "terraform_public_subnet" {
  value = aws_subnet.terraform_public_subnet
}