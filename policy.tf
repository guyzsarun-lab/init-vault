resource "vault_policy" "admin_policy" {
  name   = "admins"
  policy = file("policies/admin_policy.hcl")
}

resource "vault_policy" "root_policy" {
  name   = "root_user"
  policy = file("policies/root_policy.hcl")
}

resource "vault_policy" "view_policy" {
  name   = "viewer"
  policy = file("policies/view_policy.hcl")
}