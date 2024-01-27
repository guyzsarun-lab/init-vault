resource "vault_mount" "homelab" {
  path = "database/homelab"
  type = "database"

  description = "Homelab database secret engine"
}

resource "vault_database_secret_backend_connection" "postgres" {
  backend = vault_mount.homelab.path
  name    = "postgres"
  allowed_roles = [ for role in fileset("${path.module}/secrets/database/postgres", "*.sql") : split(".",role)[0]]

  postgresql {
    connection_url = "host=${var.postgres.host} port=${var.postgres.port} user={{username}} password={{password}} sslmode=disable"
    username       = var.postgres.username
    password       = var.postgres.password
  }
}

resource "vault_database_secret_backend_role" "postgres_role" {
  backend             = vault_mount.homelab.path
  name                = split(".",each.value)[0]
  db_name             = vault_database_secret_backend_connection.postgres.name
  creation_statements = [file("${path.module}/secrets/database/postgres/${each.value}")]

  default_ttl         = 3600
  for_each = fileset("${path.module}/secrets/database/postgres", "*.sql")
}
