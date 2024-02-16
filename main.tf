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
