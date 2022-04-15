module "aws_auth" {
  source = "../../modules/aws_auth"

  aws_auth_configmap_yaml = data.terraform_remote_state.eks.outputs.eks_aws_auth_configmap

  map_roles = [
    {
      rolearn  = "arn:aws:iam::516478179338:role/admin-eks-role"
      username = "admins"
      groups   = ["system:masters"]
    }
  ]
}

module "alb-controller" {
  source = "../../modules/aws-alb-controller"

  cluster_name = data.terraform_remote_state.eks.outputs.eks_cluster_name
  provider_url = data.terraform_remote_state.eks.outputs.eks_cluster_oidc_issuer_url
  chart_version      = "1.4.1"
}