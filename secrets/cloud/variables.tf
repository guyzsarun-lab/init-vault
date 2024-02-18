variable "path" {
  type = string
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