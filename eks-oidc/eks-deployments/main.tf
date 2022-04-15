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