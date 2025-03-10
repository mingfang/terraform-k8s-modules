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
    CASSANDRA_SEEDS           = "cassandra-0.cassandra.${var.namespace}.svc.cluster.local"
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
