variable "name" {
  default = "realtime"
}

variable "namespace" {}

variable "ports" {
  default = [
    {
      name = "tcp"
      port = 4000
    },
  ]
}

variable "replicas" {
  default = 1
}

variable "image" {
  default = "supabase/realtime:latest"
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

variable "DB_HOST" {}
variable "DB_NAME" {}
variable "DB_USER" {}
variable "DB_PASSWORD" {}
variable "DB_PORT" {}
variable "HOSTNAME" {
  default = "0.0.0.0"
}
variable "SECURE_CHANNELS" {
  default = "false"
}
variable "JWT_SECRET" {}
