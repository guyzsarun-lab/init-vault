variable "aws" {
  sensitive = true
  type = object({
    access_key = string
    secret_key = string
    region     = string
  })
}

variable "postgres" {
  sensitive = true
  type = object({
    host     = string
    port     = number
    username = string
    password = string
  })
}

variable "mongo" {
  sensitive = true
  type = object({
    host     = string
    port     = number
    username = string
    password = string
    database = string
  })
}

variable "ca_certs" {
  sensitive = true
  type = object({
    common_name     = string
    organization    = string
    country         = string
    allowed_domains = list(string)
  })
}

variable "client_certs" {
  type = list(object({
    common_name = string
    sans        = list(string)
  }))
}