variable "name" {}

variable "namespace" {
  default = "default"
}

variable "replicas" {
  default = 1
}

variable "service_type" {
  default = "LoadBalancer"
}

variable external_traffic_policy {
  default     = "Cluster"
  description = "set to null if service_type is not LoadBalancer"
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

variable "container_ports" {
  default = null
}

variable "extra_args" {
  default = []
}

variable "config_map_data" {
  default = {}
}

variable "tcp_services_data" {
  default = {}
}

variable "udp_services_data" {
  default = {}
}

variable "node_selector" {
  default     = {}
  description = "key/value pair. e.g. zone=com"
}

