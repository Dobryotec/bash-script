
terraform {
  required_version = ">= 1.5.0"   

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.12"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.23"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# S3 + DynamoDB backend
module "s3_backend" {
  source = "./modules/s3-backend"
  bucket_name = var.s3_bucket_name
  table_name  = var.dynamodb_table_name
}

# VPC
module "vpc" {
  source = "./modules/vpc"
  vpc_cidr_block     = var.vpc_cidr_block
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  availability_zones = var.availability_zones
  vpc_name           = var.vpc_name
}

# ECR
module "ecr" {
  source = "./modules/ecr"
  ecr_name       = var.ecr_name
  scan_on_push   = var.ecr_scan_on_push
  tags           = var.tags
}

# EKS
module "eks" {
  source         = "./modules/eks"
  cluster_name   = var.cluster_name
  vpc_id         = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  tags           = var.tags
}

module "jenkins" {
  source        = "./modules/jenkins"
  cluster_name  = module.eks.cluster_name
  depends_on    = [module.eks]
}

module "argo_cd" {
  source               = "./modules/argo_cd"
  cluster_name         = module.eks.cluster_name
  django_helm_repo_url = var.django_helm_repo_url
  ecr_repository_url   = module.ecr.repository_url
  depends_on           = [module.eks, module.jenkins]
}