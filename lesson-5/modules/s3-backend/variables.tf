variable "bucket_name" {
  description = "Name of S3 bucket for terraform state"
  type        = string
}

variable "table_name" {
  description = "Name of DynamoDB table for state locking"
  type        = string
  default     = "terraform-locks"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}
