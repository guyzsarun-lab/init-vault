# Enable K/V v2 secrets engine at 'kv-v2'
resource "vault_mount" "kv-v2" {
  path = "kv-v2"
  type = "kv-v2"

  description = "kv version 2 secret engine"
}

resource "vault_kv_secret_backend_v2" "kv-v2_config" {
  mount                = vault_mount.kv-v2.path
  max_versions         = 3
  delete_version_after = 1800
}

# Enable Transit secrets engine at 'transit'
resource "vault_mount" "transit" {
  path        = "transit"
  type        = "transit"
  description = "Transit secret engine"
}

resource "vault_aws_secret_backend" "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region = var.aws_region

  default_lease_ttl_seconds = 21600


  path = "aws"
  description = "aws secret engine"
}