resource "k8s_core_v1_namespace" "this" {
  metadata {
    labels = {
      "istio-injection" = "disabled"
    }

    name = var.namespace
  }
}

module "nfs-server" {
  source    = "../../modules/nfs-server-empty-dir"
  name      = "nfs-server"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
}

module "elasticsearch_storage" {
  source    = "../../modules/kubernetes/storage-nfs"
  name      = "elasticsearch"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 3
  storage   = "1Gi"

  annotations = {
    "nfs-server-uid" = "${module.nfs-server.deployment.metadata[0].uid}"
  }

  nfs_server    = module.nfs-server.service.spec[0].cluster_ip
  mount_options = module.nfs-server.mount_options
}

module "elasticsearch" {
  source    = "../../modules/elasticsearch"
  name      = "elasticsearch"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  replicas      = module.elasticsearch_storage.replicas
  storage       = module.elasticsearch_storage.storage
  storage_class = module.elasticsearch_storage.storage_class_name
}
module "redis_storage" {
  source    = "../../modules/kubernetes/storage-nfs"
  name      = "redis"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 1
  storage   = "1Gi"

  annotations = {
    "nfs-server-uid" = "${module.nfs-server.deployment.metadata[0].uid}"
  }

  nfs_server    = module.nfs-server.service.spec[0].cluster_ip
  mount_options = module.nfs-server.mount_options
}

module "redis" {
  source    = "../../modules/redis"
  name      = "redis"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  replicas      = module.redis_storage.replicas
  storage       = module.redis_storage.storage
  storage_class = module.redis_storage.storage_class_name
}

module "duckling" {
  source    = "../../modules/articulate/duckling"
  name      = "duckling"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
}

module "rasa" {
  source    = "../../modules/articulate/rasa"
  name      = "rasa"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
}

module "api" {
  source    = "../../modules/articulate/api"
  name      = "api"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  elasticsearch = "http://${module.elasticsearch.name}:${module.elasticsearch.port}"
}

module "ui" {
  source    = "../../modules/articulate/ui"
  name      = "ui"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
}

module "nginx" {
  source    = "../../modules/articulate/nginx"
  name      = "nginx"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  api = "http://${module.api.name}:${module.api.port}"
  ui  = "http://${module.ui.name}:${module.ui.port}"
}

resource "k8s_extensions_v1beta1_ingress" "this" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${var.name}.*"
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
            service_name = module.nginx.name
            service_port = module.nginx.port
          }
          path = "/"
        }
      }
    }
  }
}


