environment = "dev"
vpc_cidr    = "10.10.0.0/16"

frontend = {
  instance_type  = "t3.micro"
  instance_count = 1
}

backend = {
  instance_type  = "t3.micro"
  instance_count = 1
}

# Cheap and disposable: no standby, no backups, easy to destroy.
database = {
  db_name                 = "goldenstep"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  multi_az                = false
  backup_retention_period = 0
  deletion_protection     = false
  skip_final_snapshot     = true
}
