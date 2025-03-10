resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}


module "zookeeper" {
  source        = "../../modules/zookeeper"
  name          = "zookeeper"
  namespace     = k8s_core_v1_namespace.this.metadata[0].name
  replicas      = 1
  storage       = "1Gi"
  storage_class = "cephfs"
}

module "nifi" {
  source    = "../../modules/nifi/nifi"
  name      = var.name
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 1

  env = [
    {
      name  = "NIFI_ZK_CONNECT_STRING"
      value = "${module.zookeeper.name}:2181"
    },
    {
      name  = "NIFI_CLUSTER_IS_NODE"
      value = "true"
    },
    {
      name = "NIFI_SENSITIVE_PROPS_KEY"
      value = "123456789012"
    },
    {
      name  = "NIFI_REMOTE_INPUT_HOST"
      value = "${var.namespace}.rebelsoft.com"
    },
    {
      name = "SINGLE_USER_CREDENTIALS_USERNAME"
      value = "admin"
    },
    {
      name = "SINGLE_USER_CREDENTIALS_PASSWORD"
      value = "password9999"
    },
    {
      name = "NIFI_WEB_PROXY_HOST"
      value = "${var.namespace}.rebelsoft.com:443"
    },
  ]
}


resource "k8s_extensions_v1beta1_ingress" "nifi" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"                 = "nginx"
      "nginx.ingress.kubernetes.io/server-alias"    = "${var.namespace}.*"
      "nginx.ingress.kubernetes.io/proxy-body-size" = "11024m"
      "nginx.ingress.kubernetes.io/backend-protocol" = "HTTPS"
    }
    name      = var.namespace
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = var.namespace
      http {
        paths {
          backend {
            service_name = module.nifi.name
            service_port = module.nifi.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}
