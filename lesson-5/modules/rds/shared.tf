# DB Subnet Group
resource "aws_db_subnet_group" "this" {
  count       = var.create ? 1 : 0
  name        = "${var.cluster_identifier}-subnet-group"
  subnet_ids  = var.subnet_ids
  tags        = merge(var.tags, { Name = "${var.cluster_identifier}-subnet-group" })
}

# Security Group
resource "aws_security_group" "this" {
  count       = var.create ? 1 : 0
  name        = "${var.cluster_identifier}-sg"
  vpc_id      = var.vpc_id
  tags        = merge(var.tags, { Name = "${var.cluster_identifier}-sg" })

  ingress {
    description = "PostgreSQL/MySQL from VPC"
    from_port   = var.engine == "postgres" ? 5432 : 3306
    to_port     = var.engine == "postgres" ? 5432 : 3306
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.selected.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_vpc" "selected" {
  id = var.vpc_id
}

# Parameter Group
resource "aws_db_parameter_group" "this" {
  count  = var.create ? 1 : 0
  name   = "${var.cluster_identifier}-params"
  family = var.use_aurora ? 
    (var.engine == "postgres" ? "aurora-postgresql15" : "aurora-mysql8.0") :
    (var.engine == "postgres" ? "postgres15" : "mysql8.0")

  parameter {
    name  = "log_statement"
    value = "all"
  }
  parameter {
    name  = "work_mem"
    value = "8192"
  }

  tags = var.tags
}