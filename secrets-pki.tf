resource "vault_mount" "pki" {
  path                      = "certs"
  type                      = "pki"
  default_lease_ttl_seconds = 60 * 60 * 24 * 3650
  max_lease_ttl_seconds     = 60 * 60 * 24 * 3650
}

resource "vault_mount" "pki_int" {
  path                      = "certs_int"
  type                      = vault_mount.pki.type
  default_lease_ttl_seconds = vault_mount.pki.default_lease_ttl_seconds
  max_lease_ttl_seconds     = vault_mount.pki.max_lease_ttl_seconds
}

resource "vault_pki_secret_backend_root_cert" "root_ca" {
  depends_on           = [vault_mount.pki]
  backend              = vault_mount.pki.path
  type                 = "internal"
  common_name          = "${var.ca_certs.common_name} Root CA"
  ttl                  = "87600h"
  format               = "pem"
  private_key_format   = "der"
  key_type             = "rsa"
  key_bits             = 4096
  exclude_cn_from_sans = true
  organization         = var.ca_certs.organization
}

resource "local_file" "root_ca_cert" {
  content  = vault_pki_secret_backend_root_cert.root_ca.certificate
  filename = "${path.module}/secrets/certs/root_ca.pem"
}

resource "vault_pki_secret_backend_role" "root_ca_role" {
  backend          = vault_mount.pki.path
  name             = "root_ca_role"
  ttl              = 3600
  allow_ip_sans    = true
  key_type         = "rsa"
  key_bits         = 4096
  allowed_domains  = []
  allow_subdomains = true
}



resource "vault_pki_secret_backend_intermediate_cert_request" "intermediate_ca" {
  depends_on = [vault_mount.pki_int]

  backend     = vault_mount.pki_int.path
  type        = "internal"
  common_name = "${var.ca_certs.common_name} Intermediate Certificate"

  format             = "pem"
  private_key_format = "der"
  key_type           = "rsa"
  key_bits           = 4096
}

resource "local_file" "intermediate_ca_csr" {
  content  = vault_pki_secret_backend_intermediate_cert_request.intermediate_ca.csr
  filename = "${path.module}/secrets/certs/int_ca.csr"
}


resource "vault_pki_secret_backend_root_sign_intermediate" "root_ca_int" {
  depends_on           = [vault_pki_secret_backend_intermediate_cert_request.intermediate_ca]
  backend              = vault_mount.pki.path
  csr                  = vault_pki_secret_backend_intermediate_cert_request.intermediate_ca.csr
  common_name          = "${var.ca_certs.common_name} Intermediate Certificate"
  exclude_cn_from_sans = true
  organization         = var.ca_certs.organization
  format               = "pem_bundle"
  ttl                  = "43800h"
  revoke               = true
}

resource "vault_pki_secret_backend_intermediate_set_signed" "intermediate_ca_set_signed" {
  backend     = vault_mount.pki_int.path
  certificate = vault_pki_secret_backend_root_sign_intermediate.root_ca_int.certificate
}

resource "vault_pki_secret_backend_role" "int_ca_role" {
  backend          = vault_mount.pki_int.path
  name             = "int_ca_role"
  ttl              = 60 * 60 * 24 * 365
  allow_ip_sans    = true
  key_type         = "rsa"
  key_bits         = 4096
  allowed_domains  = var.ca_certs.allowed_domains
  allow_subdomains = true
}

resource "vault_pki_secret_backend_cert" "client_certificate" {
  depends_on = [vault_pki_secret_backend_role.int_ca_role]

  backend = vault_mount.pki_int.path
  name    = vault_pki_secret_backend_role.int_ca_role.name

  common_name = each.value.common_name
  alt_names   = each.value.sans

  for_each = {
    for index, cn in var.client_certs :
    cn.common_name => cn
  }
  revoke = true
}

resource "local_file" "client_crt" {
  for_each = vault_pki_secret_backend_cert.client_certificate
  content  = vault_pki_secret_backend_cert.client_certificate[each.key].certificate
  filename = "${path.module}/secrets/certs/${each.key}/${each.key}.pem"
}

resource "local_file" "client_key" {
  for_each = vault_pki_secret_backend_cert.client_certificate
  content  = vault_pki_secret_backend_cert.client_certificate[each.key].private_key
  filename = "${path.module}/secrets/certs/${each.key}/${each.key}.key"
}