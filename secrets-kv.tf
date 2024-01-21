# Enable K/V v2 secrets engine at 'kv-v2'
resource "vault_mount" "kv-v2" {
  path = "kv-v2"
  type = "kv-v2"

  description = "kv version 2 secret engine"
}

resource "vault_kv_secret_backend_v2" "kv-v2_config" {
  mount                = vault_mount.kv-v2.path
  max_versions         = 3
}

resource "vault_kv_secret_v2" "line_secret" {
  mount = vault_mount.kv-v2.path
  name = "/home_server/line_bot_api"

  data_json = file("${path.module}/secrets/kv/line_bot_api.json")

}

resource "vault_kv_secret_v2" "token" {
  mount = vault_mount.kv-v2.path
  name = "token"

  data_json = file("${path.module}/secrets/kv/token.json")
}