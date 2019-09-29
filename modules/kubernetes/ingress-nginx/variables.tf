variable "name" {}

variable "namespace" {
  default = null
}

variable "service_type" {
  default = "ClusterIP"
}

variable "ingress_class" {
  default = "nginx"
}

variable "load_balancer_ip" {
  default = null
}

variable "ports" {
  default = [
    {
      name        = "http"
      port        = 80
      protocol    = "TCP"
      target_port = "80"
    },
    {
      name        = "https"
      port        = 443
      protocol    = "TCP"
      target_port = "443"
    }
  ]
}

variable "extra_args" {
  default = []
}

variable "tcp_services_data" {
  default = {}
}

variable "udp_services_data" {
  default = {}
}
