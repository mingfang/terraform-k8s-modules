resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

/*
module "minio" {
  source    = "../../modules/minio"
  name      = var.name
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  replicas           = 4
  storage            = "1Gi"
  storage_class_name = "cephfs"

  minio_access_key = var.minio_access_key
  minio_secret_key = var.minio_secret_key

  policies_configmap = module.policies.config_map
  post_start_command = [
    "bash",
    "-c",
    <<-EOF
    until mc alias set minio http://localhost:9000 $MINIO_ROOT_USER $MINIO_ROOT_PASSWORD; do
      echo "Waiting for minio to start..."
      sleep 5
    done

    # create buckets
    for bucket in "test foo bar"; do
      mc mb minio/$bucket || true;
    done

    # create policies
    for FILE in /policies*/
/*.json; do
      test -f "$FILE" || continue
      echo "adding $FILE"
      FILENAME=$(basename -- "$FILE")
      POLICY="$${FILENAME%.*}"
      mc admin policy add minio $POLICY $FILE
    done

    # add policies to user
    mc admin user add minio readonly readonly12345
    mc admin policy set minio readonly-user user=readonly
    EOF
  ]
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "this" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"                 = "nginx"
      "nginx.ingress.kubernetes.io/server-alias"    = "${var.namespace}.*"
      "nginx.ingress.kubernetes.io/proxy-body-size" = "10240m"
    }
    name      = var.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = var.namespace
      http {
        paths {
          backend {
            service_name = module.minio.name
            service_port = module.minio.ports[1].port
          }
          path = "/"
        }
      }
    }
  }
}
*/

# gateway

module "policies" {
  source    = "../../modules/kubernetes/config-map"
  name      = "policies"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  from-dir = "${path.module}/policies"
}

locals {
  create_buckets = []
}
module "job" {
  source    = "../../modules/kubernetes/job"
  name      = "init"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  annotations = {
    "checksum" = module.policies.checksum
  }
  image     = "minio/mc"

  env_map = {
    "MINIO_ROOT_USER"     = var.minio_access_key
    "MINIO_ROOT_PASSWORD" = var.minio_secret_key
  }
  configmap = module.policies.config_map

  command = [
    "bash",
    "-c",
    <<-EOF
    until mc alias set minio http://${module.s3-gateway.name}:${module.s3-gateway.ports.0.port} $MINIO_ROOT_USER $MINIO_ROOT_PASSWORD; do
      echo "Waiting for minio to start..."
      sleep 5
    done

    # create buckets
    for bucket in ${length(local.create_buckets) > 0 ? join(" ", local.create_buckets) : ""}; do
    /usr/bin/mc mb minio/$bucket || true;
    done

    # create policies
    for FILE in /config/*.json; do
      test -f "$FILE" || continue
      echo "adding $FILE"
      FILENAME=$(basename -- "$FILE")
      POLICY="$${FILENAME%.*}"
      mc admin policy add minio $POLICY $FILE
    done

    # add policies to user
    mc admin user add minio readonly readonly12345
    mc admin policy set minio readonly-user user=readonly
    EOF
  ]
}

module "s3-gateway" {
  source    = "../../modules/minio"
  name      = "s3-gateway"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 1

  env_map = {
    AWS_ACCESS_KEY_ID     = var.AWS_ACCESS_KEY_ID
    AWS_SECRET_ACCESS_KEY = var.AWS_SECRET_ACCESS_KEY
    MINIO_CACHE           = "on"
    MINIO_CACHE_DRIVES    = "/var/cache"
  }
  args = ["gateway", "s3", "--console-address", ":9001"]

  minio_access_key = var.minio_access_key
  minio_secret_key = var.minio_secret_key
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "s3-gateway" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"                 = "nginx"
      "nginx.ingress.kubernetes.io/server-alias"    = "s3-${var.namespace}.*"
      "nginx.ingress.kubernetes.io/proxy-body-size" = "10240m"
    }
    name      = module.s3-gateway.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "s3-${var.namespace}"
      http {
        paths {
          backend {
            service_name = module.s3-gateway.name
            service_port = module.s3-gateway.ports[1].port
          }
          path = "/"
        }
      }
    }
  }
}
