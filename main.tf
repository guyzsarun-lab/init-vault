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

  aws_access_key = var.aws_access_key
  aws_secret_key = var.aws_secret_key
  aws_region     = var.aws_region
}

module "secrets-kv" {
  source = "./secrets/kv"
  path = "kv-v2"
}