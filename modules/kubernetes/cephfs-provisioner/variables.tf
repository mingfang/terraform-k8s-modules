variable "name" {
  default = "cephfs-provisioner"
}

variable "namespace" {
  default = "kube-system"
}

variable "image" {
  default = "quay.io/external_storage/cephfs-provisioner:latest"
}

variable "overrides" {
  default = {}
}

variable PROVISIONER_NAME {
  default = "ceph.com/cephfs"
}
