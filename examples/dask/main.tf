module "namespace" {
  source    = "../namespace"
  name      = var.namespace
  is_create = var.is_create_namespace
}

module "dask-scheduler" {
  source    = "../../modules/generic-deployment-service"
  name      = "dask-scheduler"
  namespace = module.namespace.name
  image     = "ghcr.io/dask/dask-notebook:2025.1.0"
  ports     = [{ name = "scheduler", port = 8786 }, { name = "dashboard", port = 8787 }]

  command = ["sh", "-c", <<-EOF
    pip install s3fs
    dask scheduler
    EOF
  ]
}

module "dask-worker" {
  source    = "../../modules/generic-deployment-service"
  name      = "dask-worker"
  namespace = module.namespace.name
  image     = "ghcr.io/dask/dask-notebook:2025.1.0"

  command = ["sh", "-c", <<-EOF
    pip install s3fs
    dask worker "tcp://${module.dask-scheduler.name}:${module.dask-scheduler.ports[0].port}" --nworkers 8 --nthreads 8
    EOF
  ]

  replicas                          = 1
  max_replicas                      = 3
  target_cpu_utilization_percentage = 80
  resources = {
    requests = {
      cpu    = "1"
      memory = "64Mi"
    }
  }
}

resource "k8s_networking_k8s_io_v1_ingress" "dask" {
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
              name = module.dask-scheduler.name
              port {
                number = module.dask-scheduler.ports.1.port
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
