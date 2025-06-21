locals {
  users = jsondecode(file("${path.module}/templates/users.json"))
}

resource "vault_auth_backend" "userpass" {
  type        = "userpass"
  path        = var.path
  description = "Main userpass authentication"
}

resource "vault_generic_endpoint" "users" {
  for_each             = { for user in local.users : user.username => user }
  depends_on           = [vault_auth_backend.userpass]
  path                 = "auth/userpass/users/${each.value.username}"
  ignore_absent_fields = true

  data_json = templatefile("${path.module}/templates/default_template.tftpl", { policies = sort(each.value.policies), password = each.value.password })
}
