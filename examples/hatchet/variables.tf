variable "name" {
  default = "hatchet"
}

variable "namespace" {
  default = "hatchet"
}

variable "is_create_namespace" {
  default = true
}

variable "postgres_password" {
  description = "Password for the CloudNativePG cluster."
  type        = string

}

variable "cookie_secret_1" {
  description = "First hex-encoded 16-byte cookie secret."
  type        = string

}

variable "cookie_secret_2" {
  description = "Second hex-encoded 16-byte cookie secret."
  type        = string

}

variable "erlang_cookie" {
  description = "Erlang cookie for RabbitMQ cluster."
  type        = string
}
