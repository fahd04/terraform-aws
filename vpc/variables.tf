variable "vpc_cidr_block" {
 type = string
}

variable "subnet_count" {
 type = map(string)  
}

variable "public_subnet_cidr_blocks" {
  type = list(string)
}

variable "private_subnet_cidr_blocks" {
  type = list(string)
}

