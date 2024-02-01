variable "aws_vpc_id" {
  type = string
}

variable "terraform_backend_sg_id" {
  type = string
}

variable "terraform_private_subnet" {
  type = list(any)
}

variable "settings" {
  description = "Configuration settings"
  type        = map(any)
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type = string
}