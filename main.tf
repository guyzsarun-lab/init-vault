module "policy" {
  source = "./policy"
}

module "authentication" {
  source = "./authentication"
  path   = "userpass"
}

module "secrets-aws" {
  source = "./secrets/aws"
  path   = "aws"

  aws = var.aws
}

module "secrets-kv" {
  source = "./secrets/kv"
  path   = "kv-v2"
}

module "secrets-certs" {
  source = "./secrets/certs"
  path   = "certs"

  ca_certs     = var.ca_certs
  client_certs = var.client_certs
}

module "secrets-transit" {
  source = "./secrets/transit"
  path   = "transit"
}

module "secrets-homelab" {
  source = "./secrets/homelab"
  path   = "database/homelab"

  postgres = var.homelab_postgres
}

module "secrets-cloud" {
  source = "./secrets/cloud"
  path   = "database/cloud"

  mongo = var.cloud_mongo
}
