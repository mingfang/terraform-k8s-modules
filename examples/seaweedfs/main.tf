resource "k8s_core_v1_namespace" "this" {
  count = var.create_namespace ? 1 : 0

  metadata {
    name = var.namespace
  }
}

# ── Master ───────────────────────────────────────────────────────────────────
module "seaweedfs_master" {
  source    = "../../modules/generic-deployment-service"
  name      = "${var.name}-master"
  namespace = var.namespace
  image     = var.image

  ports_map = {
    http    = 9333
    grpc    = 19333
    metrics = 9324
  }

  args = ["master", "-ip.bind=0.0.0.0", "-port=9333"]

  resources = var.resources_master
}

# ── Volume ───────────────────────────────────────────────────────────────────
module "seaweedfs_volume" {
  source    = "../../modules/generic-deployment-service"
  name      = "${var.name}-volume"
  namespace = var.namespace
  image     = var.image

  ports_map = {
    http    = 8080
    metrics = 9325
  }

  pvcs = [
    {
      name              = "data"
      mount_path        = "/data"
      size              = var.volume_storage_size
      storage_class     = var.volume_storage_class
      access_mode       = "ReadWriteOnce"
      volume_claim_name = "data"
    }
  ]

  args = [
    "volume",
    "-ip.bind=0.0.0.0",
    "-port=8080",
    "-dir=/data",
    "-max=0",
    "-master=${module.seaweedfs_master.name}:9333",
  ]

  resources = var.resources_volume
}

# ── Filer ────────────────────────────────────────────────────────────────────
module "seaweedfs_filer" {
  source    = "../../modules/generic-deployment-service"
  name      = "${var.name}-filer"
  namespace = var.namespace
  image     = var.image

  ports_map = {
    http    = 8888
    grpc    = 18888
    metrics = 9326
  }

  args = [
    "filer",
    "-ip.bind=0.0.0.0",
    "-port=8888",
    "-master=${module.seaweedfs_master.name}:9333",
  ]

  resources = var.resources_filer
}

# ── S3 Gateway ───────────────────────────────────────────────────────────────
module "seaweedfs_s3" {
  source    = "../../modules/generic-deployment-service"
  name      = "${var.name}-s3"
  namespace = var.namespace
  image     = var.image

  ports_map = {
    s3      = 8333
    metrics = 9327
  }

  args = [
    "s3",
    "-filer=${module.seaweedfs_filer.name}:8888",
    "-ip.bind=0.0.0.0",
    "-port=8333",
  ]

  resources = var.resources_s3
}

# ── Volume PVC ───────────────────────────────────────────────────────────────

resource "k8s_core_v1_persistent_volume_claim" "volume_data" {
  metadata {
    name      = "data"
    namespace = var.namespace
  }

  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = var.volume_storage_size
      }
    }
    storage_class_name = var.volume_storage_class
  }
}

# ── S3 Credentials Secret ────────────────────────────────────────────────────
resource "k8s_core_v1_secret" "s3_credentials" {
  metadata {
    name      = "${var.name}-s3-credentials"
    namespace = var.namespace
  }

  data = {
    ACCESS_KEY_ID     = base64encode(var.s3_access_key)
    ACCESS_SECRET_KEY = base64encode(var.s3_secret_key)
  }

  type = "Opaque"
}
