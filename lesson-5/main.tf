terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  type    = string
  default = "us-west-2"
}

# S3 backend module
module "s3_backend" {
  source      = "./modules/s3-backend"
  bucket_name = var.s3_bucket_name
  table_name  = var.dynamodb_table_name
  region      = var.aws_region
}

# VPC module
module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr_block     = var.vpc_cidr_block
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  availability_zones = var.availability_zones
  vpc_name           = var.vpc_name
}

# ECR module
module "ecr" {
  source      = "./modules/ecr"
  ecr_name    = var.ecr_name
  scan_on_push = var.ecr_scan_on_push
  tags        = var.tags
}

# Variables expected to be set by user or default
variable "s3_bucket_name" {
  type = string
  description = "S3 bucket name for Terraform state (create or use existing)."
  default = ""
}

variable "dynamodb_table_name" {
  type = string
  description = "DynamoDB table name for Terraform state locking."
  default = "terraform-locks"
}

variable "vpc_cidr_block" {
  type = string
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  type = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnets" {
  type = list(string)
  default = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

variable "availability_zones" {
  type = list(string)
  default = ["us-west-2a", "us-west-2b", "us-west-2c"]
}

variable "vpc_name" {
  type = string
  default = "lesson-5-vpc"
}

variable "ecr_name" {
  type = string
  default = "lesson-5-ecr"
}

variable "ecr_scan_on_push" {
  type = bool
  default = true
}

variable "tags" {
  type = map(string)
  default = {
    Project = "lesson-5"
    Owner   = "student"
  }
}
