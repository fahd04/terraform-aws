variable "name" {
  description = "Prefix used for resource names, e.g. dev-frontend."
  type        = string
}

variable "vpc_id" {
  description = "VPC to launch the instances in."
  type        = string
}

variable "subnet_ids" {
  description = "Subnets to spread instances across."
  type        = list(string)
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t3.micro"
}

variable "instance_count" {
  description = "Number of instances."
  type        = number
  default     = 1

  validation {
    condition     = var.instance_count >= 1
    error_message = "instance_count must be at least 1."
  }
}

variable "app_port" {
  description = "Port the application listens on."
  type        = number
}

variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed to reach app_port."
  type        = list(string)
  default     = []
}

variable "allowed_security_group_ids" {
  description = "Security groups allowed to reach app_port."
  type        = list(string)
  default     = []
}

variable "assign_eip" {
  description = "Attach an Elastic IP to each instance."
  type        = bool
  default     = false
}

variable "readable_secret_arns" {
  description = "Secrets Manager ARNs the instances may read (e.g. DB credentials)."
  type        = list(string)
  default     = []
}
