/**
// Example: Create a Cassandra cluster

variable "name" {}
variable "namespace" {}
variable "availability_zone" {}
variable "replicas" {}
variable "size" {}

resource "aws_ebs_volume" "volumes" {
  count             = var.replicas
  availability_zone = element(var.availability_zone, count.index)
  size              = var.size
  encrypted         = true

  tags = {
    Name   = "${var.namespace}-${var.name}-${count.index}"
    Backup = "default"
  }
}


module "storage-ebs" {
  source    = "../../../../modules/aws/aws-ebs-csi/storage-ebs"
  name      = var.name
  namespace = var.namespace

  aws_ebs_volumes = aws_ebs_volume.volumes.*
}

module "cassandra" {
  source    = "../../../../modules/cassandra"
  name      = var.name
  namespace = var.namespace

  replicas      = module.storage-ebs.replicas
  storage       = module.storage-ebs.storage
  storage_class = module.storage-ebs.storage_class_name
}
 */

terraform {
  required_providers {
    k8s = {
      source  = "mingfang/k8s"
    }
  }
}

resource "k8s_storage_k8s_io_v1_storage_class" "this" {
  metadata {
    name = "${var.namespace}-${var.name}"
  }

  _provisioner = "ebs.csi.aws.com"
  allow_volume_expansion = true
}

resource "k8s_core_v1_persistent_volume" "this" {
  count = length(var.aws_ebs_volumes)

  metadata {
    name        = "${var.aws_ebs_volumes[count.index].id}-${var.aws_ebs_volumes[count.index].availability_zone}"
    annotations = var.annotations
  }

  spec {
    storage_class_name               = k8s_storage_k8s_io_v1_storage_class.this.metadata[0].name
    persistent_volume_reclaim_policy = "Retain"
    volume_mode                      = "Filesystem"
    access_modes                     = ["ReadWriteOnce"]

    capacity = {
      storage = "${var.aws_ebs_volumes[count.index].size}Gi"
    }

    csi {
      driver        = "ebs.csi.aws.com"
      volume_handle = var.aws_ebs_volumes[count.index].id
      fstype       = var.fstype
    }
    node_affinity {
      required {
        node_selector_terms {
          match_expressions {
            key      = "topology.ebs.csi.aws.com/zone"
            operator = "In"
            values   = [var.aws_ebs_volumes[count.index].availability_zone]
          }
        }
      }
    }
  }
}

resource "k8s_core_v1_persistent_volume_claim" "this" {
  count = length(var.aws_ebs_volumes)

  metadata {
    name        = "pvc-${var.name}-${count.index}"
    namespace   = var.namespace
    annotations = merge(var.annotations, map("pv-uid", k8s_core_v1_persistent_volume.this.*.metadata.0.uid[count.index]))
  }

  spec {
    storage_class_name = k8s_core_v1_persistent_volume.this.*.spec.0.storage_class_name[count.index]
    volume_name        = k8s_core_v1_persistent_volume.this.*.metadata.0.name[count.index]
    access_modes       = ["ReadWriteOnce"]

    resources {
      requests = {
        storage = k8s_core_v1_persistent_volume.this.*.spec.0.capacity.storage[count.index]
      }
    }
  }
}
