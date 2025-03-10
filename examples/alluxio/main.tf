resource "k8s_core_v1_namespace" "this" {
  metadata {
    labels = {
      "istio-injection" = "disabled"
    }
    name = var.namespace
  }
}

module "master" {
  source    = "../../modules/alluxio/master"
  name      = "${var.name}-master"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  extra_alluxio_java_opts = join(" ", [
    "-Dalluxio.master.mount.table.root.ufs=s3a://alluxio",
    "-Dalluxio.master.audit.logging.enabled=true",
    "-Dalluxio.master.mount.table.root.option.alluxio.underfs.s3.endpoint=http://minio.minio-example.svc.cluster.local:9000",
    "-Dalluxio.master.mount.table.root.option.alluxio.underfs.s3.disable.dns.buckets=true",
    "-Dalluxio.master.mount.table.root.option.alluxio.underfs.s3a.inherit_acl=false",
    "-Dalluxio.master.mount.table.root.option.aws.accessKeyId=IUWU60H2527LP7DOYJVP",
    "-Dalluxio.master.mount.table.root.option.aws.secretKey=bbdGponYV5p9P99EsasLSu4K3SjYBEcBLtyz7wbm",
    "-Dalluxio.user.file.metadata.sync.interval=30s",
  ])
}

module "worker" {
  source    = "../../modules/alluxio/worker"
  name      = "${var.name}-worker"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  overrides = {
    update_strategy = {
      rolling_update = {
        max_unavailable = "100%"
      }
      type = "RollingUpdate"
    }
  }

  alluxio_master_hostname = module.master.service.metadata[0].name
  alluxio_master_port     = module.master.service.spec[0].ports[0].port
}

/*
module "fuse" {
  source = "../../modules/alluxio/fuse"
  name = "${var.name}-fuse"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  alluxio_master_hostname = module.master.service.metadata[0].name
  alluxio_master_port = module.master.service.spec[0].ports[0].port
  overrides = {
    image_pull_policy = "Always"
  }
}
*/

module "csi" {
  source    = "../../modules/alluxio/csi"
  name      = var.name
  namespace = k8s_core_v1_namespace.this.metadata[0].name
}

module "storage-class" {
  source          = "../../modules/alluxio/csi/storage-class"
  name            = var.name
  _provisioner    = module.csi._provisioner
  master_hostname = "${module.master.service.metadata[0].name}.${module.master.service.metadata[0].namespace}"
  master_port     = module.master.service.spec[0].ports[0].port
  domain_socket   = "/opt/domain"
  java_options    = "-Xms1M"
  mount_options   = ["allow_other"]
}

module "ingress" {
  source           = "../../modules/kubernetes/ingress-nginx"
  name             = "${var.name}-ingress"
  namespace        = k8s_core_v1_namespace.this.metadata[0].name
  ingress_class    = k8s_core_v1_namespace.this.metadata[0].name
  load_balancer_ip = "192.168.2.241"
  service_type     = "LoadBalancer"
}

resource "k8s_extensions_v1beta1_ingress" "master" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = module.ingress.ingress_class
      "nginx.ingress.kubernetes.io/server-alias" = "${var.name}.*",
    }
    name      = var.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = var.name
      http {
        paths {
          backend {
            service_name = module.master.name
            service_port = module.master.service.spec[0].ports[1].port
          }
          path = "/"
        }
      }
    }
  }
}