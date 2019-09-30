variable "name" {}

variable "namespace" {
  default = null
}

variable "replicas" {
  default = 1
}

variable "image" {
  default = "jboss/business-central-workbench:7.27.0.Final"
}

variable "overrides" {
  default = {}
}

variable "users" {
  default = [
    {
      user     = "admin"
      password = "admin12345"
      roles    = "admin,analyst,kiemgmt,rest-all"
    },
    {
      user     = "kieserver"
      password = "kieserver1!"
      roles    = "kie-server"
    },
    {
      user     = "analyst"
      password = "analyst12345"
      roles    = "analyst"
    },
    {
      user     = "developer"
      password = "developer12345"
      roles    = "developer"
    },
    {
      user     = "manager"
      password = "manager12345"
      roles    = "manager"
    },
    {
      user     = "user"
      password = "user12345"
      roles    = "user"
    },
  ]
}
