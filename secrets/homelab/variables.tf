variable "path" {
  type = string
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
