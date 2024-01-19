terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "3.24.0"
    }
  }
}

provider "vault" {
  skip_tls_verify = true
}