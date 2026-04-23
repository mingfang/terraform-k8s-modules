variable "name" {
  default = "activepieces"
}

variable "namespace" {
  default = "activepieces-example"
}

variable "is_create_namespace" {
  default = true
}

variable "AP_POSTGRES_DATABASE" {
  default = "activepieces"
}

variable "AP_POSTGRES_USERNAME" {
  default = "postgres"
}

variable "AP_POSTGRES_PASSWORD" {
  default = "activepieces"
}

variable "AP_ENCRYPTION_KEY" {
  description = "256-bit encryption key, must be a 32-character hex string. Generate with: openssl rand -hex 16"
}

variable "AP_JWT_SECRET" {
  description = "JWT secret for signing tokens, must be a 64-character hex string. Generate with: openssl rand -hex 32"
}

variable "AP_WORKER_TOKEN" {
  description = "JWT token for worker authentication. Generated with AP_JWT_SECRET."
}
