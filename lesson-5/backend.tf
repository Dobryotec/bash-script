terraform {
  required_version = ">= 1.0.0"

  backend "s3" {
    bucket         = "neo-lesson8-cicd-bucket"    
    key            = "lesson-9/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}