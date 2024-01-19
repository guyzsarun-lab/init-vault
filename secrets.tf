# Enable K/V v2 secrets engine at 'kv-v2'
resource "vault_mount" "kv-v2" {
  path = "kv-v2"
  type = "kv-v2"

  description = "kv version 2 secret engine"
}

# Enable Transit secrets engine at 'transit'
resource "vault_mount" "transit" {
  path        = "transit"
  type        = "transit"
  description = "Transit secret engine"
}