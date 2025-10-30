# lesson-5 — Terraform AWS infra (S3 backend + VPC + ECR)

## Project Description

This project creates an infrastructure in AWS that includes:

- **S3 bucket + DynamoDB** for storing and locking the Terraform state.
- **VPC** with 3 public and 3 private subnets, an **Internet Gateway**, and a
  **NAT Gateway**.
- **ECR repository** for storing Docker images with automatic image scanning
  enabled.

## Project Structure

| File / Folder         | Description                                             |
| --------------------- | ------------------------------------------------------- |
| `main.tf`             | Root configuration combining all modules                |
| `backend.tf`          | Terraform backend configuration (S3 + DynamoDB)         |
| `outputs.tf`          | Output variables for AWS resources                      |
| `modules/s3-backend/` | Creates S3 bucket and DynamoDB for Terraform state      |
| `modules/vpc/`        | Creates VPC, subnets, Internet Gateway, and NAT Gateway |
| `modules/ecr/`        | Creates ECR repository for Docker images                |
| `README.md`           | Project documentation                                   |

## Modules Description

### s3-backend

- Creates an **S3 bucket** for storing Terraform state.
- Creates a **DynamoDB table** for state locking to prevent concurrent changes.
- Ensures safe collaboration in team environments.

### vpc

- Creates a **VPC** with customizable CIDR.
- Creates **3 public and 3 private subnets** across different availability
  zones.
- Creates an **Internet Gateway** for public access.
- Creates a **NAT Gateway** for private subnet internet access.

### ecr

- Creates an **ECR repository** for storing Docker images.
- Enables **automatic image scanning** to improve security.

## Important Notes

1. **Before** running `terraform init`, make sure to **edit** the `backend.tf`
   file and replace `terraform-lesson5-demo-bucket` with your actual S3 bucket
   name.
2. If you want Terraform to automatically create the backend bucket, you can
   apply only the `s3-backend` module **without** using a backend (by
   temporarily commenting out the backend block or using a separate working
   directory for the state).  
   The simpler way is to **create the bucket manually** using the AWS Console or
   CLI and then specify it in `backend.tf`.

## Commands

1. Configure AWS credentials (for example, via `aws configure` or environment
   variables).
2. Initialize Terraform:

```bash
terraform init
```

3. See the execution plan:

```bash
terraform plan
```

4. Apply the changes to create resources:

```bash
terraform apply
```

5. Destroy the resources when no longer needed:

```bash
terraform destroy
```
