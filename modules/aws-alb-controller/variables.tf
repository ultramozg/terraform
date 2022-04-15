variable cluster_name {
  type = string
}

variable provider_url {
  type = string
  description = "OIDC cluster issuer url"
}

variable chart_version {
  type = string
  description = "Specify version of the alb-controller-aws-load-balancer-controller"
}