variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "aws_region" {
  default = "eu-west-3"
}

variable "subnet_count" {
  description   = "Number of subnets"
  type          = map(number)
  default = {
    "public"   = 2,
    "private"  = 2,
  }
}

variable "public_subnet_cidr_blocks" {
    description = "CIDR blocks for public subnets"
    type        = list(string)
    default = [ 
        "10.0.1.0/24",
        "10.0.2.0/24",
        "10.0.3.0/24",
        "10.0.4.0/24" 
    ]
}

variable "private_subnet_cidr_blocks" {
    description = "CIDR blocks for private subnets"
    type        = list(string)
    default = [ 
        "10.0.101.0/24",
        "10.0.102.0/24",
        "10.0.103.0/24",
        "10.0.104.0/24" 
    ]
}

variable "settings" {
  description = "Configuration settings"
  type        = map(any)
  default = {
    "rds" = {
        allocated_storage   = 20
        engine              = "mysql"
        engine_version      = "8.0.35"
        instance_class      = "db.t3.micro"
        db_name             = "goldenstep"
        skip_final_snapshot = true
    },
    "backend_server" = {
        count           = 1
        instance_type   = "t2.micro"
    },
    "frontend_server" = {
      count         = 1
      instance_type = "t2.micro"
    }
  } 
}

variable "db_username" {
    description = "Database username"
    type        =  string
    sensitive   = true 
}

variable "db_password" {
  description   = "Database password"
  type          = string
  sensitive     = true
}