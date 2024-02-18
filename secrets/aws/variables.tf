variable "aws" {
  sensitive = true
  type = object({
    access_key = string
    secret_key = string
    region     = string
  })
}

variable "path" {
  type = string
}