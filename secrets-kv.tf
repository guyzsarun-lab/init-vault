resource "vault_generic_secret" "kv_line_secret" {
  path = "${vault_mount.kv-v2.path}/home_server/line_bot_api"

  data_json = file("${path.module}/secrets/kv/line_bot_api.json")
}