resource "tls_private_key" "example" {
  algorithm = "RSA"
}

resource "tls_self_signed_cert" "example" {
  private_key_pem = tls_private_key.example.private_key_pem

  subject {
    common_name  = "example.com"
    organization = "ACME Examples, Inc"
  }

  validity_period_hours = 12

  allowed_uses = [
    "crl_signing",
    "cert_signing",
  ]
}

resource "aws_acm_certificate" "cert" {
  private_key      = tls_private_key.example.private_key_pem
  certificate_body = tls_self_signed_cert.example.cert_pem
}

resource "aws_ec2_client_vpn_endpoint" "vpn" {
  description = "Client VPN example"
  client_cidr_block = "10.20.0.0/22"
  split_tunnel = true
  server_certificate_arn = aws_acm_certificate.cert.arn

  authentication_options {
    type = "federated-authentication"
    saml_provider_arn = aws_iam_saml_provider.okta.arn
  }

  connection_log_options {
    enabled = false
  }

  tags = local.global_tags
}

resource "aws_ec2_client_vpn_network_association" "vpn_subnets" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.vpn.id
  subnet_id = aws_subnet.main-public.id
  security_groups = [aws_security_group.vpn_access.id]

  lifecycle {
    // The issue why we are ignoring changes is that on every change
    // terraform screws up most of the vpn assosciations
    // see: https://github.com/hashicorp/terraform-provider-aws/issues/14717
    ignore_changes = [subnet_id]
  }
}

resource "aws_ec2_client_vpn_authorization_rule" "vpn_auth_rule" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.vpn.id
  target_network_cidr = aws_vpc.main.cidr_block
  authorize_all_groups = true
}