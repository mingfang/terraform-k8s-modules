variable "name" {}

variable "namespace" {
  default = null
}
variable "image" {
  default = "registry.rebelsoft.com/alluxio-csi"
}

variable "command" {
  default = ["/usr/local/bin/alluxio-csi"]
}

variable "args" {
  default = [
    "--v=5",
    "--nodeid=$(NODE_ID)",
    "--endpoint=$(CSI_ENDPOINT)",
  ]
}

variable "domain_socket_path" {
  default = null
}

