output "s3_bucket_name" {
  value = module.s3_backend.bucket_name
}

output "dynamodb_table_name" {
  value = module.s3_backend.table_name
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "ecr_repository_url" {
  value = module.ecr.repository_url
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}