variable "name" {
  default = "buzz"
}

variable "namespace" {
  default = "buzz-example"
}

variable "is_create_namespace" {
  default = true
}

variable "minio_access_key" {
  description = "MinIO access key"
}

variable "minio_secret_key" {
  description = "MinIO secret key"
}

variable "postgres_user" {
  description = "PostgreSQL database user for Buzz"
}

variable "postgres_password" {
  description = "PostgreSQL database password for Buzz"
}

variable "postgres_db" {
  description = "PostgreSQL database name for Buzz"
}
