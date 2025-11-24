resource "aws_db_instance" "this" {
  count                  = var.create && !var.use_aurora ? 1 : 0
  identifier             = var.cluster_identifier
  engine                 = var.engine
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  allocated_storage      = var.allocated_storage
  db_name                = var.db_name
  username               = var.username
  password               = var.password
  vpc_security_group_ids = [aws_security_group.this[0].id]
  db_subnet_group_name   = aws_db_subnet_group.this[0].name
  parameter_group_name   = aws_db_parameter_group.this[0].name
  multi_az               = var.multi_az
  publicly_accessible    = var.publicly_accessible
  storage_encrypted      = true
  skip_final_snapshot    = true

  tags = merge(var.tags, { Name = var.cluster_identifier })
}