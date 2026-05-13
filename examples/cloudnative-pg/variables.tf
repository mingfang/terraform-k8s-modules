variable "name" {
  default = "cloudnative-pg"
}

variable "namespace" {
  default = "cloudnative-pg-example"
}

variable "is_create_namespace" {
  default = true
}

variable "postgres_password" {
  type = string
}

variable "postgres_user" {
  type = string
}
