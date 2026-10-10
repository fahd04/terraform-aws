variable "name" {
  description = "Prefix used for resource names."
  type        = string
}

variable "vpc_id" {
  description = "VPC to create the database in."
  type        = string
}

variable "subnet_ids" {
  description = "Private subnets for the DB subnet group (at least 2 AZs)."
  type        = list(string)

  validation {
    condition     = length(var.subnet_ids) >= 2
    error_message = "RDS requires subnets in at least 2 availability zones."
  }
}

variable "allowed_security_group_ids" {
  description = "Security groups allowed to connect on 3306."
  type        = list(string)
}

variable "engine_version" {
  description = "MySQL engine version. A major version (e.g. 8.4) lets RDS pick the latest minor."
  type        = string
  default     = "8.4"
}

variable "instance_class" {
  description = "RDS instance class."
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Initial storage in GiB."
  type        = number
  default     = 20
}

variable "max_allocated_storage" {
  description = "Upper limit for storage autoscaling in GiB."
  type        = number
  default     = 100
}

variable "db_name" {
  description = "Name of the initial database."
  type        = string
}

variable "username" {
  description = "Master username. The password is managed by RDS in Secrets Manager."
  type        = string
  default     = "admin"
}

variable "multi_az" {
  description = "Run a standby replica in a second AZ."
  type        = bool
  default     = false
}

variable "backup_retention_period" {
  description = "Days to keep automated backups (0 disables them)."
  type        = number
  default     = 7
}

variable "deletion_protection" {
  description = "Block deletion of the database."
  type        = bool
  default     = true
}

variable "skip_final_snapshot" {
  description = "Skip the final snapshot on destroy."
  type        = bool
  default     = false
}
