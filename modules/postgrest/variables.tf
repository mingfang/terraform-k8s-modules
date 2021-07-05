variable "name" {
  default = "postgrest"
}

variable "namespace" {}

variable "ports" {
  default = [
    {
      name = "tcp"
      port = 3000
    },
  ]
}

variable "replicas" {
  default = 1
}

variable "image" {
  default = "postgrest/postgrest:latest"
}

variable "env" {
  default = []
}

variable "annotations" {
  default = {}
}

variable "resources" {
  default = {
    requests = {
      cpu    = "100m"
      memory = "128Mi"
    }
  }
}

variable "overrides" {
  default = {}
}

variable "PGRST_DB_URI" {
  description = "postgres://user:password@host:port/db?sslmode=disable'"
}
variable "PGRST_DB_SCHEMA" {
  default = "public"
}
variable "PGRST_DB_ANON_ROLE" {
  default = "anon"
}
variable "PGRST_JWT_SECRET" {
  description = "`openssl rand -base64 32`"
}
