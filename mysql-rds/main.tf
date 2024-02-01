resource "aws_security_group" "terraform_rds_sg" {
    name        = "terraform_rds_sg"
    description = "Security Group for rds db"
    vpc_id      = var.aws_vpc_id

    ingress {
        description     = "Allow MySql traffic from only the backend sg"
        from_port       = "3306"
        to_port         = "3306"
        protocol        = "tcp"
        security_groups = [var.terraform_backend_sg_id]
    }

    tags = {
        Name = "terraform_rds_sg"
    }
}

resource "aws_db_subnet_group" "terraform_rds_subnet_group" {
    name        = "terraform_rds_subnet_group"
    description = "Rds Subnet group for terraform"
    subnet_ids  = [for subnet in var.terraform_private_subnet : subnet.id]
}

resource "aws_db_instance" "terraform_rds" {
    allocated_storage      = var.settings.allocated_storage
    engine                 = var.settings.engine
    engine_version         = var.settings.engine_version
    instance_class         = var.settings.instance_class
    db_name                = var.settings.db_name
    username               = var.db_username
    password               = var.db_password
    db_subnet_group_name   = aws_db_subnet_group.terraform_rds_subnet_group.id
    vpc_security_group_ids = [aws_security_group.terraform_rds_sg.id]
    skip_final_snapshot    = var.settings.skip_final_snapshot
}