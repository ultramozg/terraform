module "aws_auth" {
  source = "../../modules/aws_auth"

  aws_auth_configmap_yaml = data.terraform_remote_state.eks.outputs.eks_aws_auth_configmap

  map_roles = [
    {
      rolearn  = "arn:aws:iam::516478179338:role/admin-eks-role"
      username = "admins"
      groups   = ["system:masters"]
    },
    {
      rolearn  = data.terraform_remote_state.eks.outputs.eks_management_role_arn
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

module "cluster_autoscaler" {
  source = "../../modules/eks-cluster-autoscaler"

  enabled = true

  cluster_name                     = data.terraform_remote_state.eks.outputs.eks_cluster_name
  cluster_identity_oidc_issuer     = data.terraform_remote_state.eks.outputs.eks_cluster_oidc_issuer_url
  cluster_identity_oidc_issuer_arn = data.terraform_remote_state.eks.outputs.cluster_identity_oidc_issuer_arn
  aws_region                       = "eu-west-1"
}

module "helms" {
  source = "../../modules/helms"

  helms = {
    metrics-server = {
      chart_version = "3.8.2"
      namespace     = "kube-system"
      chart         = "metrics-server"
      repository    = "https://kubernetes-sigs.github.io/metrics-server/"

      sets = [
        {
          name  = "apiService.create"
          value = "true"
        },
        {
          name  = "containerPort"
          value = 8443
        }
      ]
    }
  }
}