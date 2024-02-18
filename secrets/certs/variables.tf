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

variable "path" {
  type = string
}