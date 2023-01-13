variable "name" {
  default = "supabase"
}

variable "namespace" {
  default = "supabase-example"
}

/* keys */

variable "ANON_KEY" {}
variable "SERVICE_ROLE_KEY" {}
variable "JWT_SECRET" {}

/* postgres */

variable "POSTGRES_DB" {
  default = "postgres"
}
variable "POSTGRES_USER" {}
variable "POSTGRES_PASSWORD" {}

/* gotrue */

variable "GOTRUE_EXTERNAL_KEYCLOAK_REDIRECT_URI" {
  default = ""
}
variable "GOTRUE_EXTERNAL_KEYCLOAK_URL" {
  default = ""
}
variable "GOTRUE_EXTERNAL_KEYCLOAK_CLIENT_ID" {
  default = ""
}
variable "GOTRUE_EXTERNAL_KEYCLOAK_SECRET" {
  default = ""
}
variable "GOTRUE_SMTP_USER" {
  default = null
}
variable "GOTRUE_SMTP_PASS" {
  default = null
}

/* storage */

variable "STORAGE_BACKEND" { default = "s3" }
variable "AWS_ACCESS_KEY_ID" {
  default = ""
}
variable "AWS_SECRET_ACCESS_KEY" {
  default = ""
}
variable "REGION" {
  default = "us-east-1"
}
variable "GLOBAL_S3_BUCKET" {
  default = "supabase"
}

/* studio */

variable "STUDIO_DEFAULT_ORGANIZATION" {
  default = "Default Organization"
}
variable "STUDIO_DEFAULT_PROJECT" {
  default = "Default Project"
}
variable "SUPABASE_PUBLIC_URL" {
  default = "https://supabase-example.rebelsoft.com"
}

