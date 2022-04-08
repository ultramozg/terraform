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
  host                   = data.terraform_remote_state.eks.outputs.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

# used to create resources on the kubernetes cluster
provider "kubernetes" {
  host                   = data.terraform_remote_state.eks.outputs.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}