variable ssh_public_key {
  type    = string
  default = "~/.ssh/id_rsa.pub"
}

locals {
  global_tags = {
    Owner      = "dmitri.candu"
    Discipline = "AM"
    Purpose    = "Learn how to configure EKS with terraform"
  }
}