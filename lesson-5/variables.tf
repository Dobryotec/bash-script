aws_region = "us-west-2"

s3_bucket_name = "neo-lesson5-demo-bucket"
dynamodb_table_name = "terraform-locks"

vpc_cidr_block = "10.0.0.0/16"
public_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
private_subnets = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c"]
vpc_name = "lesson-5-vpc"

ecr_name = "lesson-5-ecr"
ecr_scan_on_push = true

# Теги
tags = {
  Project = "lesson-5"
  Owner   = "student"
}