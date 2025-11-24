variable "create" {
  description = "Whether to create RDS/Aurora (for conditional usage)"
  type        = bool
  default     = true
}

variable "use_aurora" {
  description = "If true — an Aurora Cluster will be created, otherwise a regular RDS instance"
  type        = bool
  default     = false
}

variable "cluster_identifier" {
  description = "Identifier of the cluster (for Aurora) or the instance (for RDS)"
  type        = string
}

variable "engine" {
  description = "Database engine type (postgres or mysql)"
  type        = string
  default     = "postgres"
}

variable "engine_version" {
  description = "Database engine version"
  type        = string
  default     = "15.5"
}

variable "instance_class" {
  description = "Instance class (db.t3.medium, db.r6g.large, etc.)"
  type        = string
  default     = "db.t3.medium"
}

variable "allocated_storage" {
  description = "Allocated storage size in GB (for RDS)"
  type        = number
  default     = 20
}

variable "db_name" {
  description = "Database name"
  type        = string
}

variable "username" {
  description = "Master username"
  type        = string
  sensitive   = true
}

variable "password" {
  description = "Master password"
  type        = string
  sensitive   = true
  no_log      = true
}

variable "subnet_ids" {
  description = "List of subnet IDs for the DB Subnet Group"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID for the Security Group"
  type        = string
}

variable "multi_az" {
  description = "Multi-AZ deployment"
  type        = bool
  default     = false
}

variable "publicly_accessible" {
  description = "Whether the DB is publicly accessible"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags"
  type        = map(string)
  default     = {}
}
