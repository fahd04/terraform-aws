environment = "staging"
vpc_cidr    = "10.20.0.0/16"

frontend = {
  instance_type  = "t3.small"
  instance_count = 1
}

backend = {
  instance_type  = "t3.small"
  instance_count = 1
}

# Mirrors prod settings at a smaller size so changes are tested realistically.
database = {
  db_name                 = "goldenstep"
  instance_class          = "db.t3.small"
  allocated_storage       = 20
  multi_az                = false
  backup_retention_period = 3
  deletion_protection     = false
  skip_final_snapshot     = true
}
