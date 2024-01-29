resource "vault_auth_backend" "userpass" {
  type        = "userpass"
  path        = "userpass"
  description = "Main userpass authentication"
}

resource "vault_generic_endpoint" "devops_user" {
  depends_on           = [vault_auth_backend.userpass]
  path                 = "auth/userpass/users/devops_user"
  ignore_absent_fields = true

  data_json = templatefile("${path.module}/authentication/default_template.tftpl", { policies = sort([ "default","admin_policy"]) })
}

resource "vault_generic_endpoint" "root_user" {
  depends_on           = [vault_auth_backend.userpass]
  path                 = "auth/userpass/users/root"
  ignore_absent_fields = true

  data_json = templatefile("${path.module}/authentication/default_template.tftpl", { policies = sort(["default","root_policy"]) })
}

resource "vault_generic_endpoint" "view_user" {
  depends_on           = [vault_auth_backend.userpass]
  path                 = "auth/userpass/users/viewer"
  ignore_absent_fields = true

  data_json = templatefile("${path.module}/authentication/default_template.tftpl", { policies = sort(["default","view_policy"])})
}