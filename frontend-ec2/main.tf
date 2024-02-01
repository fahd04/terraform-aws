resource "aws_security_group" "terraform_frontend_sg" {
    name = "terraform_frontend_sg"
    description = "Security Group for the frontend server"
    vpc_id = var.aws_vpc_id

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

resource "aws_instance" "terraform_frontend" {
    count                  = var.settings.count
    ami                    = var.aws_ami_id
    instance_type          = var.settings.instance_type
    subnet_id              = var.public_subnet_id
    key_name               = var.key_name
    vpc_security_group_ids = [aws_security_group.terraform_frontend_sg.id]

    tags = {
      Name = "terraform_frontend_${count.index}"
    }
}

resource "aws_eip" "terraform_frontend_eip" {
    count = var.settings.count
    instance = aws_instance.terraform_frontend[count.index].id
    vpc = true

    tags = {
      Name = "terraform_frontend_eip_${count.index}"
    }

}