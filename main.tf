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

module "vpc" {
  source = "./vpc"
  vpc_cidr_block = var.vpc_cidr_block
  subnet_count = var.subnet_count
  public_subnet_cidr_blocks = var.public_subnet_cidr_blocks
  private_subnet_cidr_blocks = var.private_subnet_cidr_blocks
}

module "aws-key-pair" {
  source = "./aws-key-pair"
}

module "frontend-ec2" {
  source = "./frontend-ec2"
  aws_vpc_id = module.vpc.vpc_id
  key_name = module.aws-key-pair.key_name
  settings = var.settings.frontend_server
  aws_ami_id = data.aws_ami.ubuntu.id
  public_subnet_id = module.vpc.terraform_public_subnet[0].id
  depends_on = [ module.vpc, module.aws-key-pair ]
}

module "backend-ec2" {
  source = "./backend-ec2"
  aws_vpc_id = module.vpc.vpc_id
  terraform_frontend_sg_id = module.frontend-ec2.terraform_frontend_sg_id
  settings = var.settings.backend_server
  aws_ami_id = data.aws_ami.ubuntu.id
  key_name = module.aws-key-pair.key_name
  public_subnet_id = module.vpc.terraform_public_subnet[0].id
  depends_on = [ module.aws-key-pair, module.vpc, module.frontend-ec2 ]
}

module "mysql-rds" {
  source = "./mysql-rds"
  aws_vpc_id = module.vpc.vpc_id
  terraform_backend_sg_id = module.backend-ec2.terraform_backend_sg_id
  terraform_private_subnet = module.vpc.terraform_private_subnet
  settings = var.settings.rds
  db_password = var.db_password
  db_username = var.db_username
  depends_on = [ module.vpc, module.backend-ec2 ]
}