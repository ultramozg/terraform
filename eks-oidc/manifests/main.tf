data "terraform_remote_state" "eks" {
  backend = "local"

  config = {
    path = "../eks/terraform.tfstate"
  }
}

module "eks_auth" {
  source = "aidanmelen/eks-auth/aws"
  eks    = data.terraform_remote_state.eks.outputs

  map_roles = [
    {
      rolearn  = "arn:aws:iam::516478179338:role/admin-eks-role"
      username = "admins"
      groups   = ["system:masters"]
    }
  ]
}