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
    password = base64encode("postgres")
  }
}

locals {
  env_map = {
    PGDATA     = "/data"
    PGUSERNAME = "postgres"
  }

  args = [
    "-c", "work_mem=512MB",
    "-c", "maintenance_work_mem=512MB",
    "-c", "max_wal_size=1GB",
    "-c", "wal_level=logical",
    "-c", "log_statement=all",
    "-c", "max_worker_processes=128",
    "-c", "shared_preload_libraries=citus,vchord.so,pg_cron"
  ]

}

module "coordinator" {
  source    = "../../modules/generic-statefulset-service"
  name      = "coordinator"
  namespace = module.namespace.name

  image = var.image

  storage       = "1Gi"
  storage_class = "cephfs-csi"
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
      command = ["pg_isready", "--username", local.env_map.PGUSERNAME]
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
          until pg_isready --username $PGUSERNAME; do
            echo 'Waiting to start...'
            sleep 2
          done
          psql \
            --username=$PGUSERNAME \
            --command="CREATE EXTENSION IF NOT EXISTS citus;"
          psql \
            --username=$PGUSERNAME \
            --command="INSERT INTO pg_dist_authinfo(nodeid, rolename, authinfo) VALUES(0, '$PGUSERNAME', 'password=$PGPASSWORD') ON CONFLICT DO NOTHING;"
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

  storage       = "1Gi"
  storage_class = "cephfs-csi"
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
      command = ["pg_isready", "--username", local.env_map.PGUSERNAME]
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
          until pg_isready --username $PGUSERNAME; do
            echo 'Waiting to start...'
            sleep 2
          done
          psql \
            --username=$PGUSERNAME \
            --command="CREATE EXTENSION IF NOT EXISTS citus;"
          psql \
            --host=${module.coordinator.name} \
            --username=$PGUSERNAME \
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
