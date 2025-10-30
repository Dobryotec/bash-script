terraform {
  required_version = ">= 1.0.0"

  backend "s3" {
    bucket         = "terraform-lesson5-demo-bucket"
    key            = "lesson-5/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
