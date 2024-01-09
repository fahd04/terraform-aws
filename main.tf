terraform {
  required_providers {
    aws = {
        source  = "hashicorp/aws"
        version = "~> 5.0"
    }
  }
}

provider "aws" {
    region = var.aws_region
}

data "aws_availability_zones" "available" {
    state = "available"
}

resource "aws_vpc" "terraform_vpc" {
    cidr_block              = var.vpc_cidr_block
    enable_dns_hostnames    = true

    tags = {
      Name = "terraform_vpc"
    }
}

resource "aws_internet_gateway" "terraform_igw" {
    vpc_id = aws_vpc.terraform_vpc.id

    tags = {
      Name = "terraform_igw"
    }
}

resource "aws_subnet" "terraform_public_subnet" {
    vpc_id            = aws_vpc.terraform_vpc.id
    count             = var.subnet_count.public
    cidr_block        = var.public_subnet_cidr_blocks[count.index]
    availability_zone = data.aws_availability_zones.available.names[count.index]

    tags = {
        Name = "terraform_public_subnet_${count.index}"
    }
}

resource "aws_subnet" "terraform_private_subnet" {
    vpc_id            = aws_vpc.terraform_vpc.id
    count             = var.subnet_count.private
    cidr_block        = var.private_subnet_cidr_blocks[count.index]
    availability_zone = data.aws_availability_zones.available.names[count.index]

    tags = {
        Name = "terraform_private_subnet_${count.index}"
    }
}

resource "aws_route_table" "terraform_public_rt" {
    vpc_id = aws_vpc.terraform_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.terraform_igw.id
    }
}

resource "aws_route_table_association" "public" {
    route_table_id = aws_route_table.terraform_public_rt.id
    count          = var.subnet_count.public
    subnet_id      = aws_subnet.terraform_public_subnet[count.index].id 
}

resource "aws_route_table" "terraform_private_rt" {
    vpc_id = aws_vpc.terraform_vpc.id
}

resource "aws_route_table_association" "private" {
    count          = var.subnet_count.private
    route_table_id = aws_route_table.terraform_private_rt.id
    subnet_id      = aws_subnet.terraform_private_subnet[count.index].id
}

resource "aws_security_group" "terraform_frontend_sg" {
    name = "terraform_frontend_sg"
    description = "Security Group for the frontend server"
    vpc_id = aws_vpc.terraform_vpc.id

    ingress {
        description = "Allow Http traffic from frontend to backend"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks  = ["0.0.0.0/0"]
    }
    
     ingress {
        description = "Allow SSH from all addresses"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        description = "Allow all outbound traffic"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "terraform_frontend_sg"
    }
    
}

resource "aws_security_group" "terraform_backend_sg" {
    name        = "terraform_backend_sg"
    description = "Security Group for backend servce"
    vpc_id      = aws_vpc.terraform_vpc.id

    ingress {
        description  = "Allow all traffic through HTTP"
        from_port    = "80"
        to_port      = "80"
        protocol     = "tcp"
        cidr_blocks  = ["0.0.0.0/0"]
    }

    ingress {
        description     = "Allow Traffic from frontend to backend"
        from_port       = 80
        to_port         = 80
        protocol        = "tcp"
        security_groups = [aws_security_group.terraform_frontend_sg.id]
    }

    ingress {
        description = "Allow ssh from all addresses"
        from_port   = "22"
        to_port     = "22"
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        description = "Allow all outbound traffic"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
      Name = "terraform_backend_sg"
    }
}

resource "aws_security_group" "terraform_rds_sg" {
    name        = "terraform_rds_sg"
    description = "Security Group for rds db"
    vpc_id      = aws_vpc.terraform_vpc.id

    ingress {
        description     = "Allow MySql traffic from only the backend sg"
        from_port       = "3306"
        to_port         = "3306"
        protocol        = "tcp"
        security_groups = [aws_security_group.terraform_backend_sg.id]
    }

    tags = {
        Name = "terraform_rds_sg"
    }
}

resource "aws_db_subnet_group" "terraform_rds_subnet_group" {
    name        = "terraform_rds_subnet_group"
    description = "Rds Subnet group for terraform"
    subnet_ids  = [for subnet in aws_subnet.terraform_private_subnet : subnet.id]
}

resource "aws_db_instance" "terraform_rds" {
    allocated_storage      = var.settings.rds.allocated_storage
    engine                 = var.settings.rds.engine
    engine_version         = var.settings.rds.engine_version
    instance_class         = var.settings.rds.instance_class
    db_name                = var.settings.rds.db_name
    username               = var.db_username
    password               = var.db_password
    db_subnet_group_name   = aws_db_subnet_group.terraform_rds_subnet_group.id
    vpc_security_group_ids = [aws_security_group.terraform_rds_sg.id]
    skip_final_snapshot    = var.settings.rds.skip_final_snapshot
}

resource "aws_key_pair" "terraform_kp" {
    key_name = "terraform_kp"
    public_key = file("terraform_kp.pub")
}

data "aws_ami" "ubuntu" {
    most_recent = true

    filter {
      name   = "name"
      values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["099720109477"]
}

resource "aws_instance" "terraform_backend" {
    count                  = var.settings.backend_server.count
    ami                    = data.aws_ami.ubuntu.id
    instance_type          = var.settings.backend_server.instance_type
    subnet_id              = aws_subnet.terraform_public_subnet[0].id
    key_name               = aws_key_pair.terraform_kp.key_name
    vpc_security_group_ids = [aws_security_group.terraform_backend_sg.id]

    tags = {
        Name = "terraform_backend_${count.index}"
    }
}

resource "aws_instance" "terraform_frontend" {
    count                  = var.settings.frontend_server.count
    ami                    = data.aws_ami.ubuntu.id
    instance_type          = var.settings.frontend_server.instance_type
    subnet_id              = aws_subnet.terraform_public_subnet[1].id
    key_name               = aws_key_pair.terraform_kp.key_name
    vpc_security_group_ids = [aws_security_group.terraform_frontend_sg.id]

    tags = {
      Name = "terraform_frontend_${count.index}"
    }
}

resource "aws_eip" "terraform_backend_eip" {
    count = var.settings.backend_server.count
    instance = aws_instance.terraform_backend[count.index].id
    vpc = true

    tags = {
        Name = "terraform_backend_eip_${count.index}"
    }

}

resource "aws_eip" "terraform_frontend_eip" {
    count = var.settings.frontend_server.count
    instance = aws_instance.terraform_frontend[count.index].id
    vpc = true

    tags = {
      Name = "terraform_frontend_eip_${count.index}"
    }

}

