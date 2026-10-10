locals {
  name = "${var.project}-${var.environment}"
}

module "network" {
  source = "../../modules/network"

  name       = local.name
  cidr_block = var.vpc_cidr
  az_count   = var.az_count
}

module "frontend" {
  source = "../../modules/compute"

  name                = "${local.name}-frontend"
  vpc_id              = module.network.vpc_id
  subnet_ids          = module.network.public_subnet_ids
  instance_type       = var.frontend.instance_type
  instance_count      = var.frontend.instance_count
  app_port            = 80
  allowed_cidr_blocks = ["0.0.0.0/0"]
  assign_eip          = true
}

module "backend" {
  source = "../../modules/compute"

  name                       = "${local.name}-backend"
  vpc_id                     = module.network.vpc_id
  subnet_ids                 = module.network.public_subnet_ids
  instance_type              = var.backend.instance_type
  instance_count             = var.backend.instance_count
  app_port                   = var.backend.app_port
  allowed_security_group_ids = [module.frontend.security_group_id]
  readable_secret_arns       = [module.database.master_user_secret_arn]
}

module "database" {
  source = "../../modules/database"

  name                       = local.name
  vpc_id                     = module.network.vpc_id
  subnet_ids                 = module.network.private_subnet_ids
  allowed_security_group_ids = [module.backend.security_group_id]
  db_name                    = var.database.db_name
  instance_class             = var.database.instance_class
  allocated_storage          = var.database.allocated_storage
  multi_az                   = var.database.multi_az
  backup_retention_period    = var.database.backup_retention_period
  deletion_protection        = var.database.deletion_protection
  skip_final_snapshot        = var.database.skip_final_snapshot
}
