output "eks_cluster_id" {
  value = module.eks.cluster_id
}

output "eks_aws_auth_configmap" {
  value = module.eks.aws_auth_configmap_yaml
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}