resource "vault_auth_backend" "userpass" {
  type = "userpass"
}

resource "vault_generic_endpoint" "devops_user" {
  depends_on           = [vault_auth_backend.userpass]
  path                 = "auth/userpass/users/devops_user"
  ignore_absent_fields = true

  data_json = templatefile("${path.module}/secrets/userpass/default_template.tftpl", { policies = [vault_policy.admin_policy.name, "default"] })
}

resource "vault_generic_endpoint" "root_user" {
  depends_on           = [vault_auth_backend.userpass]
  path                 = "auth/userpass/users/root"
  ignore_absent_fields = true

  data_json = templatefile("${path.module}/secrets/userpass/default_template.tftpl", { policies = [vault_policy.root_policy.name, ] })
}