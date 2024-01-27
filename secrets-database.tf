resource "vault_mount" "database" {
  path = "database"
  type = "database"

  description = "Homelab database secret engine"
}

resource "vault_database_secret_backend_connection" "postgres" {
  backend = vault_mount.database.path
  name    = "postgres"
  allowed_roles = [
    "postgres_readonly",
    "postgres_root"
  ]

  postgresql {
    connection_url = "host=${var.postgres.host} port=${var.postgres.port} user={{username}} password={{password}} sslmode=disable"
    username       = var.postgres.username
    password       = var.postgres.password
  }
}

resource "vault_database_secret_backend_role" "postgres_role_readonly" {
  backend             = vault_mount.database.path
  name                = "postgres_readonly"
  db_name             = vault_database_secret_backend_connection.postgres.name
  creation_statements = ["CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}';GRANT SELECT ON ALL TABLES IN SCHEMA public TO \"{{name}}\";"]
  default_ttl         = 3600
}


resource "vault_database_secret_backend_role" "postgres_role_root" {
  backend             = vault_mount.database.path
  name                = "postgres_root"
  db_name             = vault_database_secret_backend_connection.postgres.name
  creation_statements = ["CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}';GRANT ALL ON ALL TABLES IN SCHEMA public TO \"{{name}}\";"]
  default_ttl         = 3600
}
