terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.region
}
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name   = "${var.cluster_name}-eks-cluster"

  enable_nat_gateway   = true
  enable_dns_hostnames = true

  cidr            = var.vpc_cidr
  azs             = var.azs
  private_subnets = var.private_subnets 
  public_subnets  = var.public_subnets 

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }

  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }

  tags = var.tags
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  cluster_name    = var.cluster_name
  cluster_version = var.eks_version

  cluster_endpoint_public_access = true
  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
    aws-ebs-csi-driver = {
      most_recent = true
    }
  }

  eks_managed_node_groups = {
    default = {
      min_size     = var.num_nodes
      max_size     = var.num_nodes
      desired_size = var.num_nodes

      instance_types = [var.instance_type]
      capacity_type  = "ON_DEMAND"

      # required by aws-ebs-csi-driver
      iam_role_additional_policies = {
        AmazonEBSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
      }
    }
  }

  tags = var.tags
}
