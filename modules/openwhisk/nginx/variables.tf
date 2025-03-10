variable "name" {}
variable "namespace" {}
variable "ports" {
  default = [
    {
      name = "http"
      port = 80
    }
  ]
}

variable "controller_fqdn" {
  description = "<controller>.<namespace>.svc.cluster.local"
}
variable "apigateway_fqdn" {
  description = "<apigateway>.<namespace>.svc.cluster.local"
}
