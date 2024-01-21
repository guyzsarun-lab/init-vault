resource "vault_aws_secret_backend_role" "aws_role" {
  backend = vault_aws_secret_backend.aws.path
  name    = split(".",each.value)[0]
  credential_type = "iam_user"

  policy_document = file("${path.module}/secrets/aws/${each.value}")

  for_each = fileset("${path.module}/secrets/aws", "*.json")
}
