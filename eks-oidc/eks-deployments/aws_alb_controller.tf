locals {
  k8s_aws_lb_service_account_namespace = "kube-system"
  k8s_aws_lb_service_account_name      = "aws-load-balancer-controller"
}

resource "aws_iam_policy" "AWSLoadBalancerControllerIAMPolicy" {
  name        = "AWSLoadBalancerControllerIAMPolicy"
  path        = "/"
  description = "AWS Load Balancer Controller Policy"

  # This policy was being taken from the official documentation
  # https://docs.aws.amazon.com/eks/latest/userguide/aws-load-balancer-controller.html
  policy = file("policies/iam-alb-controller-policy.json")

  tags = {
    Terraform   = "true"
  }
}

module "iam_assumable_role_aws_lb" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "3.6.0"
  create_role                   = true
  role_name                     = "AWSLoadBalancerControllerIAMRole"
  provider_url                  = replace(data.terraform_remote_state.eks.outputs.eks_cluster_oidc_issuer_url, "https://", "")
  role_policy_arns              = [aws_iam_policy.AWSLoadBalancerControllerIAMPolicy.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:${local.k8s_aws_lb_service_account_namespace}:${local.k8s_aws_lb_service_account_name}"]

  tags = {
    Terraform   = "true"
  }

}

resource "helm_release" "alb-controller" {
  name       = "alb-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"

  namespace = "kube-system"

  set {
    name  = "clusterName"
    value = data.terraform_remote_state.eks.outputs.eks_cluster_name
  }

  set {
    name  = "serviceAccount.name"
    value = local.k8s_aws_lb_service_account_name
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.iam_assumable_role_aws_lb.this_iam_role_arn
  }
}