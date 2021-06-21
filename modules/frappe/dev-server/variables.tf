variable "name" {}

variable "namespace" {}

variable "ports" {
  default = [
    {
      name = "tcp"
      port = 8000
    },
    {
      name = "socketio"
      port = 443
    },
  ]
}

variable "image" {
  default = "registry.rebelsoft.com/frappe"
}

variable "replicas" {
  default = 1
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
      cpu    = "500m"
      memory = "256Mi"
    }
  }
}

variable "overrides" {
  default = {}
}

variable "SITE_NAME" {
  default = "default"
}
variable "AUTO_MIGRATE" {
  default = "1"
}
variable "GET_APPS" {
  default     = "frappe"
  description = "space seperated list of apps to get initially"
}
variable "ADMIN_PASSWORD" {
  default = "frappe"
}

variable "POSTGRES_HOST" {
  default = null
}
variable "POSTGRES_PASSWORD" {
  default = null
}
variable "MARIADB_HOST" {
  default = null
}
variable "MYSQL_ROOT_PASSWORD" {
  default = null
}
variable "DB_PORT" {
  default     = null
  description = "database port"
}
variable "DB_ROOT_USER" {
  default = "root"
}
variable "REDIS_CACHE" {
  default     = null
  description = "redis-cache:6379"
}
variable "REDIS_QUEUE" {
  default     = null
  description = "redis-queue:6379"
}
variable "REDIS_SOCKETIO" {
  default     = null
  description = "redis-socketio:6379"
}
variable "SOCKETIO_PORT" {
  default     = 443
  description = "443"
}

variable "pvc_sites" {
  default = null
}
