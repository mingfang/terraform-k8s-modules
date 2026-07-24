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

variable "relay_private_key" {
  description = "Hex-encoded relay private key (required when BUZZ_REQUIRE_RELAY_MEMBERSHIP=true)"
}

variable "relay_owner_pubkey" {
  description = "Hex-encoded secp256k1 public key derived from relay_private_key"
}
