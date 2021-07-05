variable "name" {
  default = "gotrue"
}

variable "namespace" {}

variable "ports" {
  default = [
    {
      name = "tcp"
      port = 9999
    },
  ]
}

variable "replicas" {
  default = 1
}

variable "image" {
  default = "supabase/gotrue:latest"
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

variable "API_EXTERNAL_URL" {}
variable "GOTRUE_SITE_URL" {}
variable "GOTRUE_API_HOST" {
  default = "0.0.0.0"
}

variable "GOTRUE_OPERATOR_TOKEN" {}
variable "GOTRUE_JWT_SECRET" {}
variable "GOTRUE_JWT_EXP" {
  default = 3600
}
variable "GOTRUE_JWT_DEFAULT_GROUP_NAME" {
  default = "authenticated"
}

variable "GOTRUE_DB_DRIVER" {
  default = "postgres"
}
variable "DATABASE_URL" {
  description = "postgres://user:password@host:port/db?sslmode=disable'"
}
variable "DB_NAMESPACE" {
  default = "auth"
}

variable "GOTRUE_DISABLE_SIGNUP" {
  default = "false"
}
variable "GOTRUE_MAILER_AUTOCONFIRM" {
  default = "true"
}
variable "GOTRUE_LOG_LEVEL" {
  default = "INFO"
}

variable "GOTRUE_SMTP_HOST" {}
variable "GOTRUE_SMTP_PORT" {}
variable "GOTRUE_SMTP_USER" {}
variable "GOTRUE_SMTP_PASS" {}
