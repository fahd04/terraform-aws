variable "aws_vpc_id" {
  type = string
}

variable "terraform_frontend_sg_id" {
  type = string
}

variable "settings" {
  description = "Configuration settings"
  type        = map(any)
}

variable "aws_ami_id" {
  type = string
}

variable "key_name" {
  type = any
}

variable "public_subnet_id" {
  type = string
}