resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "provisioner" {
  source    = "../../modules/aws/yandex-s3-csi/provisioner"
  name      = "provisioner"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
}

module "csi-s3" {
  source    = "../../modules/aws/yandex-s3-csi/csi-s3"
  name      = "csi-s3"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
}

module "attacher" {
  source    = "../../modules/aws/yandex-s3-csi/attacher"
  name      = "attacher"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
}

module "secret" {
  source    = "../../modules/kubernetes/secret"
  name      = "s3fs"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  from-map  = {
    accessKeyID     = base64encode(var.AWS_ACCESS_KEY_ID)
    secretAccessKey = base64encode(var.AWS_SECRET_ACCESS_KEY)
    endpoint        = base64encode("https://s3.us-east-1.amazonaws.com")
  }
}

module "storage-class" {
  source      = "../../modules/aws/yandex-s3-csi/storage-class"
  name        = "s3fs"
  namespace   = k8s_core_v1_namespace.this.metadata[0].name
  secret_name = module.secret.name
}

locals {
  volume_name = var.namespace
}
resource "k8s_core_v1_persistent_volume" "s3" {
  metadata {
    name = local.volume_name
  }
  spec {
    storage_class_name = local.volume_name
    capacity = {
      storage = "10Gi"
    }
    access_modes = ["ReadWriteMany"]
    csi {
      driver = "ru.yandex.s3.csi"
      controller_publish_secret_ref {
        name      = module.secret.name
        namespace = var.namespace
      }
      node_publish_secret_ref {
        name      = module.secret.name
        namespace = var.namespace
      }
      node_stage_secret_ref {
        name      = module.secret.name
        namespace = var.namespace
      }
      volume_attributes = {
        "capacity"     = "10Gi"
        "mounter"      = "geesefs"
      }
      volume_handle = "rebelsoft-s3fs/${local.volume_name}"
    }
  }
}

resource "k8s_core_v1_persistent_volume_claim" "s3" {
  metadata {
    name      = local.volume_name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }

  spec {
    access_modes       = ["ReadWriteMany"]
    resources { requests = { "storage" = "1Gi" } }
    storage_class_name = local.volume_name
    volume_name = local.volume_name
  }
}

module "test" {
  source    = "../../modules/generic-deployment-service"
  name      = "test"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  image     = "ubuntu"
  command   = ["sleep", "infinity"]
  pvc       = k8s_core_v1_persistent_volume_claim.s3.metadata[0].name

}