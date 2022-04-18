output "eks_cluster_id" {
  value = module.eks.cluster_id
}

output "eks_cluster_name" {
  value = local.name
}

output "eks_aws_auth_configmap" {
  value = module.eks.aws_auth_configmap_yaml
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "eks_cluster_oidc_issuer_url" {
value = module.eks.cluster_oidc_issuer_url
}

output "cluster_identity_oidc_issuer_arn" {
  value = module.eks.oidc_provider_arn
}