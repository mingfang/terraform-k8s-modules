module "namespace" {
  source    = "../namespace"
  name      = var.namespace
  is_create = var.is_create_namespace
}

module "secret" {
  source    = "../../modules/kubernetes/secret"
  name      = "secret"
  namespace = module.namespace.name

  from-map = {
    password = base64encode(var.password)
  }
}

locals {
  env_map = {
    PGDATA        = "/data"
    POSTGRES_USER = var.username
    POSTGRES_DB   = var.database
  }

  args = concat(
    [
      "-c", "max_connections=400",
      "-c", "shared_buffers=512MB",
      "-c", "effective_cache_size=2GB",
      "-c", "work_mem=512MB",
      "-c", "maintenance_work_mem=512MB",
      "-c", "max_wal_size=1GB",
      "-c", "wal_level=logical",
      "-c", "log_statement=ddl",
      "-c", "max_worker_processes=128",
      "-c", "shared_preload_libraries=${var.shared_preload_libraries}"
    ],
    var.args
  )

}

module "coordinator" {
  source    = "../../modules/generic-statefulset-service"
  name      = "coordinator"
  namespace = module.namespace.name

  image = var.image

  storage       = var.coordinator_storage
  storage_class = var.coordinator_storage_class
  mount_path    = "/data"

  ports_map = {
    tcp = 5432
  }

  args    = local.args
  env_map = local.env_map

  env = [
    {
      name = "HOSTNAME"
      value_from = {
        field_ref = {
          field_path = "metadata.name"
        }
      }
    },
    {
      name = "POD_IP"
      value_from = {
        field_ref = {
          field_path = "status.podIP"
        }
      }
    },
    {
      name = "PGPASSWORD"
      value_from = {
        secret_key_ref = {
          name = module.secret.name
          key  = "password"
        }
      }
    },
    {
      name = "POSTGRES_PASSWORD"
      value_from = {
        secret_key_ref = {
          name = module.secret.name
          key  = "password"
        }
      }
    },
  ]

  liveness_probe = {
    exec = {
      command = [
        "pg_isready",
        "--username", local.env_map.POSTGRES_USER,
        "--dbname", local.env_map.POSTGRES_DB,
      ]
    }
    initial_delay_seconds = 60
  }

  life_cycle = {
    post_start = {
      exec = {
        command = [
          "sh",
          "-cx",
          <<-EOF
          until pg_isready --username $POSTGRES_USER; do
            echo 'Waiting to start...'
            sleep 2
          done
          psql \
            --username=$POSTGRES_USER \
            --dbname=$POSTGRES_DB \
            --command="CREATE EXTENSION IF NOT EXISTS citus;"
          psql \
            --username=$POSTGRES_USER \
            --dbname=$POSTGRES_DB \
            --command="INSERT INTO pg_dist_authinfo(nodeid, rolename, authinfo) VALUES(0, '$POSTGRES_USER', 'password=$PGPASSWORD') ON CONFLICT DO NOTHING;"
        EOF
        ]
      }
    }
  }

  resources = {
    requests = {
      cpu    = "500m"
      memory = "1Gi"
    }
  }

  volumes = [
    {
      name = "shm"

      empty_dir = {
        "medium" = "Memory"
      }
      mount_path = "/dev/shm"
    },
  ]
}

module "worker" {
  source    = "../../modules/generic-statefulset-service"
  name      = "worker"
  namespace = module.namespace.name

  replicas = var.replicas

  image = var.image

  storage       = var.worker_storage
  storage_class = var.worker_storage_class
  mount_path    = "/data"

  ports_map = {
    tcp = 5432
  }

  args    = local.args
  env_map = local.env_map

  env = [
    {
      name = "HOSTNAME"
      value_from = {
        field_ref = {
          field_path = "metadata.name"
        }
      }
    },
    {
      name = "POD_IP"
      value_from = {
        field_ref = {
          field_path = "status.podIP"
        }
      }
    },
    {
      name = "PGPASSWORD"
      value_from = {
        secret_key_ref = {
          name = module.secret.name
          key  = "password"
        }
      }
    },
    {
      name = "POSTGRES_PASSWORD"
      value_from = {
        secret_key_ref = {
          name = module.secret.name
          key  = "password"
        }
      }
    },
  ]

  liveness_probe = {
    exec = {
      command = [
        "pg_isready",
        "--username", local.env_map.POSTGRES_USER,
        "--dbname", local.env_map.POSTGRES_DB,
      ]
    }
    initial_delay_seconds = 60
  }

  life_cycle = {
    post_start = {
      exec = {
        command = [
          "sh",
          "-cx",
          <<-EOF
          until pg_isready --username $POSTGRES_USER; do
            echo 'Waiting to start...'
            sleep 2
          done
          psql \
            --username=$POSTGRES_USER \
            --dbname=$POSTGRES_DB \
            --command="CREATE EXTENSION IF NOT EXISTS citus;"
          psql \
            --host=${module.coordinator.name} \
            --username=$POSTGRES_USER \
            --dbname=$POSTGRES_DB \
            --command="SELECT * from master_add_node('$HOSTNAME.worker.${module.namespace.name}.svc.cluster.local', 5432);"
          EOF
        ]
      }
    }
  }

  resources = {
    requests = {
      cpu    = "500m"
      memory = "1Gi"
    }
  }

  volumes = [
    {
      name = "shm"

      empty_dir = {
        "medium" = "Memory"
      }
      mount_path = "/dev/shm"
    },
  ]
}
