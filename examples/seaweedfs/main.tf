resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

locals {
  master_grpc_port  = var.ports.master_grpc
  master_http_port  = var.ports.master_http
  volume_http_port  = var.ports.volume_http
  filer_http_port   = var.ports.filer_http
  s3_port           = var.ports.s3
}

# ── Master ───────────────────────────────────────────────────────────────────
module "seaweedfs_master" {
  source    = "../generic-deployment-service"
  name      = "${var.name}-master"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  image = var.image

  ports_map = {
    grpc  = local.master_grpc_port
    http  = local.master_http_port
    metrics = var.metrics_port.master_grpc
  }

  args = ["master", "-ip.bind=0.0.0.0", "-port=${local.master_grpc_port}"]

  resources = var.resources_master
}

# ── Volume ───────────────────────────────────────────────────────────────────
module "seaweedfs_volume" {
  source    = "../generic-deployment-service"
  name      = "${var.name}-volume"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  image = var.image

  ports_map = {
    http    = local.volume_http_port
    metrics = var.metrics_port.volume_http
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
    "-port=${local.volume_http_port}",
    "-dir=/data",
    "-max=${var.volume_max_file_system_usage}",
    "-master=${module.seaweedfs_master.name}:${local.master_grpc_port}",
  ]

  resources = var.resources_volume
}

# ── Filer ────────────────────────────────────────────────────────────────────
module "seaweedfs_filer" {
  source    = "../generic-deployment-service"
  name      = "${var.name}-filer"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  image = var.image

  ports_map = {
    http    = local.filer_http_port
    metrics = var.metrics_port.filer_http
  }

  args = [
    "filer",
    "-ip.bind=0.0.0.0",
    "-port=${local.filer_http_port}",
    "-master=${module.seaweedfs_master.name}:${local.master_grpc_port}",
  ]

  resources = var.resources_filer
}

# ── S3 Gateway ───────────────────────────────────────────────────────────────
module "seaweedfs_s3" {
  source    = "../generic-deployment-service"
  name      = "${var.name}-s3"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  image = var.image

  ports_map = {
    s3      = local.s3_port
    metrics = var.metrics_port.s3
  }

  args = [
    "s3",
    "-filer=${module.seaweedfs_filer.name}:${local.filer_http_port}",
    "-ip.bind=0.0.0.0",
    "-port=${local.s3_port}",
  ]

  resources = var.resources_s3
}

# ── S3 Credentials Secret ────────────────────────────────────────────────────
resource "k8s_core_v1_secret" "s3_credentials" {
  metadata {
    name      = "${var.name}-s3-credentials"
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }

  data = {
    ACCESS_KEY_ID     = base64encode(var.s3_access_key)
    ACCESS_SECRET_KEY = base64encode(var.s3_secret_key)
  }

  type = "Opaque"
}
