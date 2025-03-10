variable "name" {
  type    = string
  default = "keycloak"
}

variable "namespace" {
  type = string
}

variable "image" {
  type    = string
  default = "quay.io/keycloak/keycloak:13.0.1"
}

variable "replicas" {
  type    = number
  default = 1
}

variable "ports" {
  default = [
    {
      name = "http"
      port = 8080
    },
  ]
}


variable "env" {
  type    = list(object({ name = string, value = string }))
  default = []
}

variable "env_map" {
  type    = map
  default = {}
}

variable "env_file" {
  type    = string
  default = null
}

variable "env_from" {
  type    = list
  default = []
}

variable "annotations" {
  type    = map
  default = {}
}

variable "node_selector" {
  default = {}
}

variable "resources" {
  default = {
    requests = {
      cpu    = "250m"
      memory = "64Mi"
    }
  }
}

variable "overrides" {
  default = {}
}

variable "post_start_command" {
  type    = list(string)
  default = null
}

variable "KEYCLOAK_USER" {}

variable "KEYCLOAK_PASSWORD" {}

/*
h2 for the embedded H2 database,
postgres for the Postgres database,
mysql for the MySql database.
mariadb for the MariaDB database.
oracle for the Oracle database.
mssql for the Microsoft SQL Server database.
*/
variable "DB_VENDOR" {
  default = "h2"
}

variable "DB_ADDR" {
  default = ""
}
variable "DB_PORT" {
  default = ""
}
variable "DB_USER" {
  default = ""
}
variable "DB_PASSWORD" {
  default = ""
}
variable "DB_DATABASE" {
  default = ""
}
variable "DB_SCHEMA" {
  default = ""
}

variable "PROXY_ADDRESS_FORWARDING" {
  default = true
}
