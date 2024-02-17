module "policy" {
  source = "./policy"
}

module "authentication" {
  source = "./authentication"
  path   = "userpass"
}

module "secrets-aws" {
  source = "./secrets/aws"
  path = "aws"

  aws = var.aws
}

module "secrets-kv" {
  source = "./secrets/kv"
  path = "kv-v2"
}

module "secrets-certs" {
  source = "./secrets/certs"
  path = "certs"

  ca_certs = var.ca_certs
  client_certs = var.client_certs
}
