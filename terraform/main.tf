provider "aws" {
  region = var.region
}

provider "kubernetes" {
  config_path = var.kubeconfig
}

provider "helm" {
  kubernetes {
    config_path = var.kubeconfig
  }
}

module "vpc" {
  source = "./modules/vpc"

  name           = "chaos-vpc"
  cidr           = "10.0.0.0/16"
  azs            = ["us-west-2a", "us-west-2b", "us-west-2c"]
  public_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

module "eks" {
  source = "./modules/eks"

  cluster_name    = "chaos-lab"
  cluster_version = "1.28"
  subnet_ids      = module.vpc.public_subnets
  vpc_id          = module.vpc.vpc_id

  node_groups = {
    default = {
      instance_types = ["t3.medium"]
      desired_size   = 2
      max_size       = 3
      min_size       = 1
    }
  }
}

module "helm_apps" {
  source     = "./modules/helm_apps"
  depends_on = [module.eks]
}