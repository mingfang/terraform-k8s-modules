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

module "zeebe_storage" {
  source    = "../../modules/kubernetes/storage-nfs"
  name      = "zeebe"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 3
  storage   = "1Gi"

  annotations = {
    "nfs-server-uid" = "${module.nfs-server.deployment.metadata[0].uid}"
  }

  nfs_server    = module.nfs-server.service.spec[0].cluster_ip
  mount_options = module.nfs-server.mount_options
}

module "zeebe" {
  source    = "../../modules/zeebe/zeebe"
  name      = "zeebe"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  replicas      = module.zeebe_storage.replicas
  storage       = module.zeebe_storage.storage
  storage_class = module.zeebe_storage.storage_class_name

  ZEEBE_LOG_LEVEL   = "debug"
  elasticsearch_url = "http://${module.elasticsearch.name}:9200"
}

module "operate" {
  source    = "../../modules/zeebe/operate"
  name      = "operate"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  CAMUNDA_OPERATE_ELASTICSEARCH_HOST       = module.elasticsearch.name
  CAMUNDA_OPERATE_ZEEBEELASTICSEARCH_HOST  = module.elasticsearch.name
  CAMUNDA_OPERATE_ZEEBE_BROKERCONTACTPOINT = "${module.zeebe.name}:26500"
}

resource "k8s_extensions_v1beta1_ingress" "this" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "zeebe.*"
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
            service_name = module.operate.name
            service_port = 8080
          }
          path = "/"
        }
      }
    }
  }
}






