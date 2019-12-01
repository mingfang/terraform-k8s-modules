variable "name" {}

variable "namespace" {
  default = null
}

variable "replicas" {
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

variable "image" {
  default = "jboss/keycloak:8.0.0"
}

variable "env" {
  default = []
}

variable "annotations" {
  default = {}
}

variable "overrides" {
  default = {}
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