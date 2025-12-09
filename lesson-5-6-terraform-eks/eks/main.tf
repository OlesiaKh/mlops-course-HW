provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.29"

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnets

  cluster_endpoint_public_access = true

  enable_irsa = true

  eks_managed_node_groups = {
    cpu = {
      instance_types = ["t3.micro"]
      min_size       = 1
      max_size       = 1
      desired_size   = 1

      labels = {
        workload = "cpu"
      }

      tags = {
        Name = "${var.cluster_name}-cpu-ng"
      }
    }

    gpu = {
      instance_types = ["t3.micro"] # умовна "GPU"-група для ДЗ
      min_size       = 1
      max_size       = 1
      desired_size   = 1

      labels = {
        workload = "gpu"
      }

      tags = {
        Name = "${var.cluster_name}-gpu-ng"
      }
    }
  }

  tags = {
    Project = var.cluster_name
    Managed = "terraform"
  }
}
