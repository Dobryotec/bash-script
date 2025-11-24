resource "aws_rds_cluster" "this" {
  count                  = var.create && var.use_aurora ? 1 : 0
  cluster_identifier     = var.cluster_identifier
  engine                 = var.engine == "postgres" ? "aurora-postgresql" : "aurora-mysql"
  engine_version         = var.engine_version
  database_name          = var.db_name
  master_username        = var.username
  master_password        = var.password
  vpc_security_group_ids = [aws_security_group.this[0].id]
  db_subnet_group_name   = aws_db_subnet_group.this[0].name
  db_cluster_parameter_group_name = aws_db_parameter_group.this[0].name
  storage_encrypted      = true
  skip_final_snapshot    = true

  tags = var.tags
}

resource "aws_rds_cluster_instance" "this" {
  count              = var.create && var.use_aurora ? 1 : 0
  identifier         = "${var.cluster_identifier}-writer"
  cluster_identifier = aws_rds_cluster.this[0].id
  instance_class     = var.instance_class
  engine             = aws_rds_cluster.this[0].engine
  engine_version     = aws_rds_cluster.this[0].engine_version
  publicly_accessible = var.publicly_accessible

  tags = var.tags
}