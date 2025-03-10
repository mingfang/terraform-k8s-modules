module "namespace" {
  source    = "../namespace"
  name      = var.namespace
  is_create = var.is_create_namespace
}

module "cassandra" {
  source    = "../../modules/generic-statefulset-service"
  name      = "cassandra"
  namespace = module.namespace.name
  image     = "cassandra"
  replicas  = 2

  ports_map = {
    cql            = 9042
    intra-node     = 7000
    intra-node-tls = 7001
    jmx            = 7199
    rpc            = 9160
  }

  env_map = {
    CASSANDRA_CLUSTER_NAME    = var.namespace
    CASSANDRA_DC              = "dc1"
    CASSANDRA_RACK            = "rack1"
    MAX_HEAP_SIZE             = "$(REQUESTS_MEMORY)M"
    HEAP_NEWSIZE              = "100M"
    CASSANDRA_LISTEN_ADDRESS  = "$(POD_IP)"
    CASSANDRA_ENDPOINT_SNITCH = "GossipingPropertyFileSnitch"
    CASSANDRA_SEEDS           = "${module.cassandra.name}-0.${module.cassandra.name}.${var.namespace}.svc.cluster.local"
    CASSANDRA_NUM_TOKENS      = 16
  }

  _lifecycle = {
    pre_stop = {
      exec = {
        command = ["/bin/sh", "-c", "nodetool drain"]
      }
    }
  }

  init_containers = [
    {
      name  = "init"
      image = "cassandra"

      command = [
        "sh",
        "-cx",
        <<-EOF
          sysctl -w vm.max_map_count=1048575
          EOF
      ]

      security_context = {
        privileged = true
        run_asuser = "0"
      }
    },
  ]

  resources = {
    requests = {
      cpu    = "500m"
      memory = "512Mi"
    }
    limits = {
      memory = "1Gi"
    }
  }

  storage    = "1Gi"
  mount_path = "/var/lib/cassandra"
}

module "config" {
  source    = "../../modules/kubernetes/config-map"
  name      = "config"
  namespace = module.namespace.name

  from-map = {
    "quine.conf" = templatefile("${path.module}/quine.conf", {
      cassandra_endpoint         = "${module.cassandra.name}:${module.cassandra.ports[0].port}"
      cassandra_local_datacenter = "dc1"
    })
  }
  from-file = "${path.module}/recipe.yml"
}

module "quine" {
  source    = "../../modules/generic-deployment-service"
  name      = "quine"
  namespace = module.namespace.name
  annotations = {
    "config-checksum" = module.config.checksum
  }
  image    = "thatdot/quine"
  replicas = 1
  ports    = [{ name = "tcp", port = 8080 }]

  command = ["bash", "-cx", <<-EOF
    exec java \
      -Dconfig.file=/config/quine.conf \
      -XX:+AlwaysPreTouch \
      -XX:+UseParallelGC \
      -XX:InitialRAMPercentage=40.0 \
      -XX:MaxRAMPercentage=80.0 \
      -jar /quine-assembly-*.jar \
      -r /config/recipe.yml \
      --force-config
    EOF
  ]

  configmap = module.config.config_map
}

resource "k8s_networking_k8s_io_v1_ingress" "this" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${var.namespace}.*"
    }
    name      = module.quine.name
    namespace = module.namespace.name
  }
  spec {
    rules {
      host = var.namespace
      http {
        paths {
          backend {
            service {
              name = module.quine.name
              port {
                number = module.quine.ports[0].port
              }
            }
          }
          path      = "/"
          path_type = "ImplementationSpecific"
        }
      }
    }
  }
}
