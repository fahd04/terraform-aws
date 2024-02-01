resource "aws_security_group" "terraform_backend_sg" {
    name        = "terraform_backend_sg"
    description = "Security Group for backend servce"
    vpc_id      = var.aws_vpc_id

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
        security_groups = [var.terraform_frontend_sg_id]
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

resource "aws_instance" "terraform_backend" {
    count                  = var.settings.count
    ami                    = var.aws_ami_id
    instance_type          = var.settings.instance_type
    subnet_id              = var.public_subnet_id
    key_name               = var.key_name
    vpc_security_group_ids = [aws_security_group.terraform_backend_sg.id]

    tags = {
        Name = "terraform_backend_${count.index}"
    }
}

resource "aws_eip" "terraform_backend_eip" {
    count = var.settings.count
    instance = aws_instance.terraform_backend[count.index].id
    vpc = true

    tags = {
        Name = "terraform_backend_eip_${count.index}"
    }

}
