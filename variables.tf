variable "aws_access_key" {
  type      = string
  sensitive = true
}

variable "aws_secret_key" {
  type      = string
  sensitive = true
}

variable "aws_region" {
  type      = string
  sensitive = true
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
    common_name = string
    organization = string
    country = string
  })
}

variable "client_certs" {
  type = list(object({
    common_name = string
    sans = list(string)
  }))
}