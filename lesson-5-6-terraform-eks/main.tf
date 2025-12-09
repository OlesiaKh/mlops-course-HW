provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

locals {
  vpc_name     = "${var.project_name}-vpc"
  cluster_name = "${var.project_name}-eks"
}

module "vpc" {
  source = "./vpc"

  aws_region  = var.aws_region
  aws_profile = var.aws_profile

  name     = local.vpc_name
  vpc_cidr = var.vpc_cidr
  azs      = var.availability_zones
}

module "eks" {
  source = "./eks"

  aws_region      = var.aws_region
  aws_profile     = var.aws_profile
  cluster_name    = local.cluster_name
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
}

