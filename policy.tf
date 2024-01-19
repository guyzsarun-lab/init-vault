resource "vault_policy" "admin_policy" {
  name   = "admins"
  policy = file("policies/admin-policy.hcl")
}

resource "vault_policy" "root_policy" {
  name   = "root_user"
  policy = file("policies/root-policy.hcl")
}