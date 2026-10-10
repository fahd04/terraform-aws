variable "name" {
  description = "Prefix used for resource names."
  type        = string
}

variable "cidr_block" {
  description = "CIDR block for the VPC. Must be /16 so each subnet gets a /24."
  type        = string

  validation {
    condition     = can(cidrhost(var.cidr_block, 0)) && endswith(var.cidr_block, "/16")
    error_message = "cidr_block must be a valid /16 CIDR, e.g. 10.0.0.0/16."
  }
}

variable "az_count" {
  description = "Number of availability zones to spread subnets across (RDS needs at least 2)."
  type        = number
  default     = 2

  validation {
    condition     = var.az_count >= 2 && var.az_count <= 4
    error_message = "az_count must be between 2 and 4."
  }
}
