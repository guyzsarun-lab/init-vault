# Enable Transit secrets engine at 'transit'
resource "vault_mount" "transit" {
  path        = var.path
  type        = "transit"
  description = "Transit secret engine"
}
