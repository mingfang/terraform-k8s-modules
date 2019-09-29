/**
 * Create a set of PersistentVolumes and a coresponding set of PersistentVolumeClaims.
 *
 * Useful for used with the VolumeClaimTemplates of StatefulSets.
 *
 */

resource "k8s_core_v1_persistent_volume" "this" {
  count = var.replicas

  metadata {
    name        = "pvc-${var.name}-${count.index}"
    annotations = var.annotations
  }

  spec {
    storage_class_name               = var.name
    persistent_volume_reclaim_policy = "Retain"
    access_modes                     = ["ReadWriteOnce"]

    capacity = {
      storage = var.storage
    }

    cephfs {
      user     = "${var.user}"
      monitors = "${var.monitors}"
      path     = "${var.path}"

      secret_ref {
        name      = "${var.secret_name}"
        namespace = "${var.secret_namespace}"
      }
    }

    mount_options = var.mount_options
  }
}

resource "k8s_core_v1_persistent_volume_claim" "this" {
  count = var.replicas

  metadata {
    name        = element(k8s_core_v1_persistent_volume.this.*.metadata.0.name, count.index)
    namespace   = var.namespace
    annotations = merge(var.annotations, map("pv-uid", element(k8s_core_v1_persistent_volume.this.*.metadata.0.uid, count.index)))
  }

  spec {
    storage_class_name = element(k8s_core_v1_persistent_volume.this.*.spec.0.storage_class_name, count.index)
    volume_name        = element(k8s_core_v1_persistent_volume.this.*.metadata.0.name, count.index)
    access_modes       = ["ReadWriteOnce"]

    resources {
      requests = {
        storage = element(k8s_core_v1_persistent_volume.this.*.spec.0.capacity.storage, count.index)
      }
    }
  }
}
