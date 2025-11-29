# backend.tf — Final Project
terraform {
  required_version = ">= 1.5.0"

  backend "s3" {
    bucket         = "final-project-tfstate-2025-do-not-delete" 
    key            = "final-project/terraform.tfstate"           
    region         = "us-west-2"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}