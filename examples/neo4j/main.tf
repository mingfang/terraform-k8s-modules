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

resource "k8s_core_v1_persistent_volume_claim" "plugins" {
  metadata {
    name      = "plugins"
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }

  spec {
    access_modes       = ["ReadWriteMany"]
    resources { requests = { "storage" = "1Gi" } }
    storage_class_name = "cephfs"
  }
}

module "install-plugins-job" {
  source    = "../../modules/kubernetes/job"
  name      = "install-plugins-job"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  image     = "busybox"

  pvcs = [
    {
      name       = k8s_core_v1_persistent_volume_claim.plugins.metadata[0].name
      mount_path = "/plugins"
    }
  ]

  command = [
    "sh",
    "-cx",
    <<-EOF
      cd /plugins
      wget -nc https://github.com/neo4j-labs/neosemantics/releases/download/5.15.0/neosemantics-5.15.0.jar || true
    EOF
  ]
}

module "neo4j" {
  source    = "../../modules/neo4j"
  name      = var.name
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  image    = "neo4j:5.16.0-enterprise"
  replicas = local.replicas

  storage_class = "cephfs"
  storage       = "1Gi"
  mount_path    = "/data"
  pvc_user      = "neo4j"

  pvcs = [
    {
      name       = k8s_core_v1_persistent_volume_claim.plugins.metadata[0].name
      mount_path = "/plugins"
    }
  ]

  env_map = {
    NEO4J_AUTH                            = "none"
    NEO4J_server_default__listen__address = "0.0.0.0"

    /* n10s */
    NEO4J_dbms_unmanaged__extension__classes = "n10s.endpoint=/rdf"

    /* enterprise only */

    NEO4J_ACCEPT_LICENSE_AGREEMENT                = "eval"
    NEO4J_initial_dbms_default__primaries__count  = local.replicas
    NEO4J_dbms_cluster_discovery_endpoints        = local.servers
    NEO4J_server_default__advertised__address     = "$(POD_NAME).${var.name}.${var.namespace}.svc.cluster.local"
    NEO4J_server_discovery_advertised__address    = "$(POD_NAME).${var.name}.${var.namespace}.svc.cluster.local:5000"
    NEO4J_server_cluster_advertised__address      = "$(POD_NAME).${var.name}.${var.namespace}.svc.cluster.local:6000"
    NEO4J_server_cluster_raft_advertised__address = "$(POD_NAME).${var.name}.${var.namespace}.svc.cluster.local:7000"

    /* Server side routing is required */
    NEO4J_dbms_routing_enabled               = "true"
    NEO4J_dbms_routing_default__router       = "SERVER"
    NEO4J_server_routing_advertised__address = "$(POD_NAME).${var.name}.${var.namespace}.svc.cluster.local:7688"
  }
}


/*
When connecting, the protocol must be neo4j+s:// for server side routing and the hostname must end in :443,
otherwise it will default to port 7474
*/

module "neo4j-proxy" {
  source    = "../../modules/neo4j/proxy"
  name      = "neo4j-proxy"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  env_map = {
    SERVICE_NAME = var.name
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
