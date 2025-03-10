variable "name" {
  default = "minio"
}

variable "namespace" {
  default = "minio"
}

variable "ingress-ip" {
  default = "192.168.2.146"
}

variable "ingress-node-port" {
  default = "30080"
}

variable minio_access_key {
  default = ""
}

variable minio_secret_key {
  default = ""
}
