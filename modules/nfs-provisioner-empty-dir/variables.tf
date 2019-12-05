variable "name" {}

variable "namespace" {
  default = null
}

variable "ports" {
  default = [
    {
      name = "nfs"
      port = 2049
    },
    {
      name = "mountd"
      port = 20048
    },
    {
      name = "rpcbind"
      port = 111
    },
    {
      name     = "rpcbind-udp"
      port     = 111
      protocol = "UDP"
    },
  ]
}

variable "image" {
  default = "quay.io/kubernetes_incubator/nfs-provisioner"
}

variable "overrides" {
  default = {}
}

//Set to Memory to use tmpfs
variable "medium" {
  default = ""
}

variable "storage_class" {
  default = "nfs-provisioner"
}

variable "is_default_class" {
  default = false
}

// Delete or Retain
variable "reclaim_policy" {
  default = "Retain"
}

variable "allow_volume_expansion" {
  default = true
}

variable "mount_options" {
  default = [
    "vers=4.1",
    "noatime",
  ]
}

