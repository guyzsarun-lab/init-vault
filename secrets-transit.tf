# Enable Transit secrets engine at 'transit'
resource "vault_mount" "transit" {
  path        = "transit"
  type        = "transit"
  description = "Transit secret engine"
}
