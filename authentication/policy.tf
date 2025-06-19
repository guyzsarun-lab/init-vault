resource "vault_policy" "policies" {
  name     = split(".", each.value)[0]
  policy   = file("${path.module}/templates/policy/${each.value}")
  for_each = fileset("${path.module}/templates/policy/", "*.hcl")
}