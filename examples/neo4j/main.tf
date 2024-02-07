resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

locals {
  replicas = 3
  servers  = join(",",
    [
      for i in range(0, local.replicas) :
      "${var.name}-${i}.${var.name}.${var.namespace}.svc.cluster.local:5000"
    ]
  )
}

module "neo4j" {
  source    = "../../modules/neo4j"
  name      = var.name
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  image    = "neo4j:5.16.0-enterprise"
  replicas = local.replicas

  env_map = {
    NEO4J_AUTH                            = "none"
    NEO4J_server_default__listen__address = "0.0.0.0"

    /* enterprise only */

    NEO4J_ACCEPT_LICENSE_AGREEMENT                = "eval"
    NEO4J_initial_dbms_default__primaries__count  = local.replicas
    NEO4J_dbms_cluster_discovery_endpoints        = local.servers
    NEO4J_server_default__advertised__address     = "$(POD_NAME).${var.name}.${var.namespace}.svc.cluster.local"
    NEO4J_server_discovery_advertised__address    = "$(POD_NAME).${var.name}.${var.namespace}.svc.cluster.local:5000"
    NEO4J_server_cluster_advertised__address      = "$(POD_NAME).${var.name}.${var.namespace}.svc.cluster.local:6000"
    NEO4J_server_cluster_raft_advertised__address = "$(POD_NAME).${var.name}.${var.namespace}.svc.cluster.local:7000"
  }
}


/* When connecting, the hostname must end in :443, otherwise it will default to port 7474 */

module "neo4j-proxy" {
  source    = "../../modules/neo4j/proxy"
  name      = "neo4j-proxy"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  env_map = {
    SERVICE_NAME = "neo4j"
    NAMESPACE    = var.namespace
    DOMAIN       = "cluster.local"
    PORT         = 8080
  }
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "this" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${var.namespace}.*"
      "nginx.ingress.kubernetes.io/ssl-redirect" = "true"
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
            service_name = module.neo4j-proxy.name
            service_port = module.neo4j-proxy.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}
