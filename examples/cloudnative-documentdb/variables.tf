variable "name" {
  default = "cloudnative-documentdb"
}

variable "namespace" {
  default = "cloudnative-documentdb-example"
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

variable "seaweedfs_access_key" {
  type = string
}

variable "seaweedfs_secret_key" {
  type = string
}
