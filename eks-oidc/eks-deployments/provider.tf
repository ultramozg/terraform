terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
    }
  }
}

provider "aws" {
  region  = "eu-west-1"
  profile = "my-admin-account"
}

provider "kubectl" {
  host                   = data.terraform_remote_state.eks.outputs.eks_cluster_endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
}

# used to create resources on the kubernetes cluster
provider "kubernetes" {
  host                   = data.terraform_remote_state.eks.outputs.eks_cluster_endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

provider "helm" {
  kubernetes {
    host                   = data.terraform_remote_state.eks.outputs.eks_cluster_endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.cluster.token
    /*
    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
      command     = "aws"
    }
    */
  }
}