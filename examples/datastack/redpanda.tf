module "redpanda" {
  source    = "../../modules/redpanda"
  name      = "redpanda"
  namespace = var.namespace

  storage_class = "cephfs"
  storage       = "1Gi"
  replicas      = 4

  additional_args = join(" ", [
    "--set redpanda.enable_transactions=true",
    "--set redpanda.enable_idempotence=true",
    "--set redpanda.auto_create_topics_enabled=true",
  ])
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "redpanda" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${var.namespace}-redpanda.*"
    }
    name      = module.redpanda.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${var.namespace}-redpanda"
      http {
        paths {
          path = "/"
          backend {
            service_name = module.redpanda.name
            service_port = module.redpanda.ports[0].port
          }
        }
      }
    }
  }
}

resource "k8s_core_v1_persistent_volume_claim" "connect-data" {
  metadata {
    name      = "connect-data"
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }

  spec {
    access_modes       = ["ReadWriteMany"]
    resources { requests = { "storage" = "1Gi" } }
    storage_class_name = "cephfs"
  }
}

module "connect-config" {
  source = "../../modules/kubernetes/config-map"
  name      = "connect"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  from-map = {
    "connect-file-pulse-source.json" = <<-EOF
    {
      "name": "test",
      "config": {
        "connector.class": "io.streamthoughts.kafka.connect.filepulse.source.FilePulseSourceConnector",
        "tasks.max": 1,
        "tasks.reader.class": "io.streamthoughts.kafka.connect.filepulse.reader.RowFileInputReader",
        "fs.cleanup.policy.class": "io.streamthoughts.kafka.connect.filepulse.clean.LogCleanupPolicy",
        "topic": "test",
        "fs.listing.class": "io.streamthoughts.kafka.connect.filepulse.fs.AmazonS3FileSystemListing",
        "aws.access.key.id": "${var.minio_access_key}",
        "aws.secret.access.key": "${var.minio_secret_key}",
        "aws.s3.service.endpoint": "http://${module.minio.name}:${module.minio.ports[0].port}",
        "aws.s3.bucket.name": "test"
      }
    }
    EOF
  }
}
module "connect" {
  source    = "../../modules/confluentinc/connect"
  name      = "connect"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 1

  configmap = module.connect-config.config_map
  pvc = k8s_core_v1_persistent_volume_claim.connect-data.metadata[0].name
  plugins = [
    "streamthoughts/kafka-connect-file-pulse:2.6.0"
  ]

  CONNECT_BOOTSTRAP_SERVERS   = "${module.redpanda.name}:${module.redpanda.ports[1].port}"
  CONNECT_SCHEMA_REGISTRY_URL = "http://${module.redpanda.name}:${module.redpanda.ports[2].port}"
}

module "kowl_config" {
  source    = "../../modules/kubernetes/config-map"
  name      = "kowl"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  from-map = {
    "config.yml" = <<-EOF
    kafka:
      brokers: ["${module.redpanda.name}:${module.redpanda.ports[1].port}"]
      schemaRegistry:
        enabled: true
        urls: ["http://${module.redpanda.name}:${module.redpanda.ports[2].port}"]
    connect:
      enabled: true
      clusters:
      - name: ${module.connect.name}
        url: http://${module.connect.name}:${module.connect.ports[0].port}
    EOF
  }
}

module "kowl" {
  source    = "../../modules/kowl"
  name      = "kowl"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  configmap = module.kowl_config.config_map
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "kowl" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${var.namespace}-kowl.*"
    }
    name      = module.kowl.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${var.namespace}-kowl"
      http {
        paths {
          path = "/"
          backend {
            service_name = module.kowl.name
            service_port = module.kowl.ports[0].port
          }
        }
      }
    }
  }
}
