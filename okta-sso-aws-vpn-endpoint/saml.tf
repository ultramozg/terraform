resource "aws_iam_saml_provider" "okta" {
  name                   = "my-okta"
  saml_metadata_document = file("saml-metadata/okta-metadata.xml")
}