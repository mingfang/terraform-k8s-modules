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
      name = "tcp"
      port = 3306
    },
  ]
}

variable image {
  default = "mysql"
}

variable "env" {
  default = []
}


variable "overrides" {
  default = {}
}

variable "storage_class" {}

variable "storage" {}

variable "volume_claim_template_name" {
  default = "pvc"
}


variable MYSQL_USER {}

variable MYSQL_PASSWORD {}

variable MYSQL_DATABASE {}

variable "MYSQL_ROOT_PASSWORD" {}
