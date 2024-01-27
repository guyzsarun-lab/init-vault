resource "vault_mount" "cloud_database" {
  path = "cloud"
  type = "database"

  description = "Cloud database secret engine"
}

resource "vault_database_secret_backend_connection" "mongo" {
  backend = vault_mount.cloud_database.path
  name    = "mongo"
  allowed_roles = [ for role in fileset("${path.module}/secrets/database/mongo", "*.json") : split(".",role)[0]]

  mongodb {
    connection_url = "mongodb://{{username}}:{{password}}@${var.mongo.host}:${var.mongo.port}"
    username       = var.mongo.username
    password       = var.mongo.password
  }
}

resource "vault_database_secret_backend_role" "mongo_role" {
  backend             = vault_mount.cloud_database.path
  name                = split(".",each.value)[0]
  db_name             = vault_database_secret_backend_connection.mongo.name
  creation_statements = [
    file("${path.module}/secrets/database/mongo/${each.value}")
  ]
  default_ttl         = 3600
  for_each = fileset("${path.module}/secrets/database/mongo", "*.json")
}
