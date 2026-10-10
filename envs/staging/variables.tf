variable "project" {
  description = "Project name, used as a prefix for every resource."
  type        = string
  default     = "goldenstep"
}

variable "environment" {
  description = "Deployment environment."
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment must be one of: dev, staging, prod."
  }
}

variable "aws_region" {
  description = "AWS region to deploy into."
  type        = string
  default     = "eu-west-3"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC (/16)."
  type        = string
}

variable "az_count" {
  description = "Number of availability zones."
  type        = number
  default     = 2
}

variable "frontend" {
  description = "Frontend server settings."
  type = object({
    instance_type  = string
    instance_count = number
  })
}

variable "backend" {
  description = "Backend server settings."
  type = object({
    instance_type  = string
    instance_count = number
    app_port       = optional(number, 8080)
  })
}

variable "database" {
  description = "RDS MySQL settings."
  type = object({
    db_name                 = string
    instance_class          = string
    allocated_storage       = number
    multi_az                = bool
    backup_retention_period = number
    deletion_protection     = bool
    skip_final_snapshot     = bool
  })
}
