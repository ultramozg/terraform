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
