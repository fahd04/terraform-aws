environment = "prod"
vpc_cidr    = "10.30.0.0/16"
az_count    = 3

frontend = {
  instance_type  = "t3.medium"
  instance_count = 2
}

backend = {
  instance_type  = "t3.medium"
  instance_count = 2
}

# Highly available and protected against accidental deletion.
database = {
  db_name                 = "goldenstep"
  instance_class          = "db.t3.medium"
  allocated_storage       = 50
  multi_az                = true
  backup_retention_period = 14
  deletion_protection     = true
  skip_final_snapshot     = false
}
