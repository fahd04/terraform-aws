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