variable "name" {
  default = "cephfs-csi"
}

variable "namespace" {
  default = "cephfs-csi"
}

variable "config_json" {
  default = "[]"
  description = "clusterID and monitors"
}