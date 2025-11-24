output "endpoint" {
  description = "Endpoint бази даних"
  value = var.use_aurora ? 
    aws_rds_cluster.this[0].endpoint : 
    aws_db_instance.this[0].endpoint
}

output "port" {
  value = var.engine == "postgres" ? 5432 : 3306
}

output "arn" {
  value = var.use_aurora ? 
    aws_rds_cluster.this[0].arn : 
    aws_db_instance.this[0].arn
}

output "db_name" {
  value = var.db_name
}