resource "aws_security_group" "this" {
  name_prefix = "${var.name}-db-"
  description = "Security group for ${var.name} database"
  vpc_id      = var.vpc_id

  ingress {
    description     = "MySQL from allowed security groups"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = var.allowed_security_group_ids
  }

  tags = { Name = "${var.name}-db-sg" }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_db_subnet_group" "this" {
  name_prefix = "${var.name}-"
  description = "Private subnets for ${var.name} database"
  subnet_ids  = var.subnet_ids
}

resource "aws_db_instance" "this" {
  identifier_prefix = "${var.name}-"

  engine                     = "mysql"
  engine_version             = var.engine_version
  auto_minor_version_upgrade = true
  instance_class             = var.instance_class
  allocated_storage          = var.allocated_storage
  max_allocated_storage      = var.max_allocated_storage
  storage_type               = "gp3"
  storage_encrypted          = true

  db_name  = var.db_name
  username = var.username
  # Password is generated and rotated by RDS in Secrets Manager; it never touches Terraform state.
  manage_master_user_password = true

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.this.id]
  publicly_accessible    = false
  multi_az               = var.multi_az

  backup_retention_period   = var.backup_retention_period
  deletion_protection       = var.deletion_protection
  skip_final_snapshot       = var.skip_final_snapshot
  final_snapshot_identifier = var.skip_final_snapshot ? null : "${var.name}-final"
}
