resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}


module "core" {
  source    = "../../modules/neo4j/core"
  name      = "${var.name}-core"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = var.replicas

  storage       = "1Gi"
  storage_class = var.storage_class_name

  NEO4J_ACCEPT_LICENSE_AGREEMENT = "yes"
  //  image = "neo4j:3.5.22"
}

/*
module "read-replica" {
  source = "../../modules/neo4j/read-replica"
  name = "${var.name}-read-replica"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas = 3

  NEO4J_ACCEPT_LICENSE_AGREEMENT = "yes"
  NEO4J_causal__clustering_initial__discovery__members = module.core.discovery_members
}
*/

resource "k8s_networking_k8s_io_v1beta1_ingress" "core" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "neo4j-core.*"
    }
    name      = module.core.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = module.core.name
      http {
        paths {
          backend {
            service_name = module.core.name
            service_port = 7474
          }
          path = "/"
        }
      }
    }
  }
}
resource "k8s_networking_k8s_io_v1beta1_ingress" "bolt" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "neo4j-bolt.*"
    }
    name      = "${module.core.name}-bolt"
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${module.core.name}-bolt"
      http {
        paths {
          backend {
            service_name = module.core.name
            service_port = 7687
          }
          path = "/"
        }
      }
    }
  }
}

/*
resource "k8s_networking_k8s_io_v1beta1_ingress" "read-replica" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "neo4j-read-replica.*"
    }
    name      = module.read-replica.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = module.read-replica.name
      http {
        paths {
          backend {
            service_name = module.read-replica.name
            service_port = 7474
          }
          path = "/"
        }
      }
    }
  }
}
*/

