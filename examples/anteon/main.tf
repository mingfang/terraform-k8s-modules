module "namespace" {
  source    = "../namespace"
  name      = var.namespace
  is_create = var.is_create_namespace
}

module "anteon-frontend" {
  source    = "../../modules/generic-deployment-service"
  name      = "anteon-frontend"
  namespace = module.namespace.name
  image     = "ddosify/selfhosted_frontend:4.1.5"
  ports     = [{ name = "tcp", port = 3000 }]
}

module "backend" {
  source    = "../../modules/generic-deployment-service"
  name      = "backend"
  namespace = module.namespace.name
  image     = "ddosify/selfhosted_backend:3.2.9"
  ports     = [{ name = "tcp", port = 8008 }]
  command   = ["/workspace/start_scripts/start_app_onprem.sh"]
  env_file  = "${path.module}/.env"
}

module "backend-celery-worker" {
  source    = "../../modules/generic-deployment-service"
  name      = "backend-celery-worker"
  namespace = module.namespace.name
  image     = "ddosify/selfhosted_backend:3.2.9"
  command   = ["/workspace/start_scripts/start_celery_worker.sh"]
  env_file  = "${path.module}/.env"
}

module "backend-celery-beat" {
  source    = "../../modules/generic-deployment-service"
  name      = "backend-celery-beat"
  namespace = module.namespace.name
  image     = "ddosify/selfhosted_backend:3.2.9"
  command   = ["/workspace/start_scripts/start_celery_beat.sh"]
  env_file  = "${path.module}/.env"
}

module "alaz-backend" {
  source    = "../../modules/generic-deployment-service"
  name      = "alaz-backend"
  namespace = module.namespace.name
  image     = "ddosify/selfhosted_alaz_backend:2.3.11"
  ports     = [{ name = "tcp", port = 8008 }]
  command   = ["/workspace/start_scripts/start_app_onprem.sh"]
  env_file  = "${path.module}/.env"
}

module "alaz-backend-celery-worker" {
  source    = "../../modules/generic-deployment-service"
  name      = "alaz-backend-celery-worker"
  namespace = module.namespace.name
  image     = "ddosify/selfhosted_alaz_backend:2.3.11"
  replicas  = 2
  command   = ["/workspace/start_scripts/start_celery_worker.sh"]
  env_file  = "${path.module}/.env"
}

module "alaz-backend-celery-beat" {
  source    = "../../modules/generic-deployment-service"
  name      = "alaz-backend-celery-beat"
  namespace = module.namespace.name
  image     = "ddosify/selfhosted_alaz_backend:2.3.11"
  command   = ["/workspace/start_scripts/start_celery_beat.sh"]
  env_file  = "${path.module}/.env"
}

module "alaz-backend-request-writer" {
  source    = "../../modules/generic-deployment-service"
  name      = "alaz-backend-request-writer"
  namespace = module.namespace.name
  image     = "ddosify/selfhosted_alaz_backend:2.3.11"
  command   = ["/workspace/start_scripts/start_request_writer.sh"]
  env_file  = "${path.module}/.env"
}

module "hammermanager" {
  source    = "../../modules/generic-deployment-service"
  name      = "hammermanager"
  namespace = module.namespace.name
  image     = "ddosify/selfhosted_hammermanager:2.0.2"
  ports     = [{ name = "tcp", port = 8001 }]
  command   = ["/workspace/start_scripts/start_app.sh"]
  env_file  = "${path.module}/.env"
}

module "hammermanager-celery-worker" {
  source    = "../../modules/generic-deployment-service"
  name      = "hammermanager-celery-worker"
  namespace = module.namespace.name
  image     = "ddosify/selfhosted_hammermanager:2.0.2"
  command   = ["/workspace/start_scripts/start_celery_worker.sh"]
  env_file  = "${path.module}/.env"
}

module "hammermanager-celery-beat" {
  source    = "../../modules/generic-deployment-service"
  name      = "hammermanager-celery-beat"
  namespace = module.namespace.name
  image     = "ddosify/selfhosted_hammermanager:2.0.2"
  command   = ["/workspace/start_scripts/start_celery_beat.sh"]
  env_file  = "${path.module}/.env"
}

module "hammer" {
  source    = "../../modules/generic-deployment-service"
  name      = "hammer"
  namespace = module.namespace.name
  image     = "ddosify/selfhosted_hammer:2.0.0"
  env_file  = "${path.module}/.env"
}

module "postgres" {
  source    = "../../modules/generic-statefulset-service"
  name      = "postgres"
  namespace = module.namespace.name
  image     = "postgres:17"
  ports     = [{ name = "tcp", port = 5432 }]
  storage   = "1Gi"

  env_file                = "${path.module}/.env"
  config_files            = ["${path.module}/init_scripts/01_postgres_create_dbs.sql"]
  config_files_mount_path = "/docker-entrypoint-initdb.d"
}

module "influxdb" {
  source    = "../../modules/generic-statefulset-service"
  name      = "influxdb"
  namespace = module.namespace.name
  image     = "influxdb:2.6.1-alpine"
  ports     = [{ name = "tcp", port = 8086 }]
  storage   = "1Gi"

  env_file = "${path.module}/.env"
  env_map = {
    DOCKER_INFLUXDB_INIT_MODE   = "setup"
    DOCKER_INFLUXDB_INIT_ORG    = "ddosify"
    DOCKER_INFLUXDB_INIT_BUCKET = "hammerBucket"
  }
  config_files            = ["${path.module}/init_scripts/01_influxdb_create_buckets.sh"]
  config_files_mount_path = "/docker-entrypoint-initdb.d"
}

module "rabbitmq" {
  source    = "../../modules/generic-deployment-service"
  name      = "rabbitmq"
  namespace = module.namespace.name
  image     = "rabbitmq:3.13.1-alpine"
  ports     = [{ name = "tcp", port = 5672 }]
}

module "redis-backend" {
  source    = "../../modules/generic-deployment-service"
  name      = "redis-backend"
  namespace = module.namespace.name
  image     = "redis:7.2.4-alpine"
  ports     = [{ name = "tcp", port = 6379 }]
}

module "redis-alaz-backend" {
  source    = "../../modules/generic-deployment-service"
  name      = "redis-alaz-backend"
  namespace = module.namespace.name
  image     = "redis:7.2.4-alpine"
  ports     = [{ name = "tcp", port = 6379 }]
}

module "seaweedfs" {
  source    = "../../modules/generic-statefulset-service"
  name      = "seaweedfs"
  namespace = module.namespace.name
  image     = "chrislusf/seaweedfs:3.64"
  ports     = [{ name = "tcp", port = 8333 }]
  storage   = "1Gi"
  args      = ["server", "-s3", "-dir=/data"]
}

module "prometheus" {
  source     = "../../modules/generic-statefulset-service"
  name       = "prometheus"
  namespace  = module.namespace.name
  image      = "prom/prometheus:v2.37.9"
  ports      = [{ name = "tcp", port = 9090 }]
  storage    = "1Gi"
  mount_path = "/prometheus"
  pvc_user   = "nobody"

  args = [
    "--config.file=/prometheus/prometheus.yml",
    "--storage.tsdb.path=/prometheus",
    "--web.console.libraries=/usr/share/prometheus/console_libraries",
    "--web.console.templates=/usr/share/prometheus/consoles",
    "--storage.tsdb.retention=10d",
  ]

  config_files            = ["${path.module}/init_scripts/prometheus.yml"]
  config_files_mount_path = "/prometheus"
}

resource "k8s_networking_k8s_io_v1_ingress" "anteon" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${var.namespace}.*"
      "nginx.ingress.kubernetes.io/ssl-redirect" = "true"
    }
    name      = var.namespace
    namespace = module.namespace.name
  }
  spec {
    rules {
      host = var.namespace
      http {
        paths {
          backend {
            service {
              name = module.anteon-frontend.name
              port {
                number = module.anteon-frontend.ports.0.port
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

resource "k8s_networking_k8s_io_v1_ingress" "anteon-api" {
  metadata {
    annotations = {
      "ingress.kubernetes.io/rewrite-target" = "/"
    }
    name      = "${var.namespace}-anteon-api"
    namespace = module.namespace.name
  }
  spec {
    rules {
      host = var.namespace
      http {
        paths {
          backend {
            service {
              name = module.backend.name
              port {
                number = module.backend.ports.0.port
              }
            }
          }
          path      = "/api/"
          path_type = "ImplementationSpecific"
        }
        paths {
          backend {
            service {
              name = module.alaz-backend.name
              port {
                number = module.alaz-backend.ports.0.port
              }
            }
          }
          path      = "/api-alaz/"
          path_type = "ImplementationSpecific"
        }
      }
    }
  }
}

/*
# Deploy Alaz with Kubectl
MONITORING_ID=08ca1f6d-416b-4b41-9120-3cdb2ddc6bcb
curl -sSL https://raw.githubusercontent.com/getanteon/alaz/master/resources/alaz.yaml -o alaz.yaml
sed -i"" -e "s/<MONITORING_ID>/$MONITORING_ID/g" alaz.yaml
sed -i"" -e "s/https:\/\/api-alaz.getanteon.com:443/https:\/\/anteon-example.rebelsoft.com\/api-alaz/g" alaz.yaml
kubectl create namespace anteon
kubectl apply -f alaz.yaml
*/

module "alaz-agent" {
  source    = "../../modules/generic-daemonset"
  name      = "alaz-agent"
  namespace = module.namespace.name
  image     = "ddosify/alaz:v0.11.4"

  env_map = {
    TRACING_ENABLED            = "true"
    METRICS_ENABLED            = "true"
    LOGS_ENABLED               = "false"
    BACKEND_HOST               = "http://${module.alaz-backend.name}:${module.alaz-backend.ports[0].port}"
    LOG_LEVEL                  = "1"
    EXCLUDE_NAMESPACES         = "^anteon.*"
    MONITORING_ID              = "08ca1f6d-416b-4b41-9120-3cdb2ddc6bcb"
    SEND_ALIVE_TCP_CONNECTIONS = "false"
  }

  args = [
    "--no-collector.wifi",
    "--no-collector.hwmon",
    "--collector.filesystem.ignored-mount-points=^/(dev|proc|sys|var/lib/docker/.+|var/lib/kubelet/pods/.+)($|/)",
    "--collector.netclass.ignored-devices=^(veth.*)$",
  ]

  cluster_role_rules   = yamldecode(replace(file("${path.module}/alaz-rbac.yaml"), "apiGroup", "api_group")).rules

  host_pid = true
  security_context = {
    privileged = true
  }

  volumes = [
    {
      name = "debugfs"
      host_path = {
        path = "/sys/kernel/debug"
      }
      mount_path = "/sys/kernel/debug"
    }
  ]
}
