module "namespace" {
  source    = "../namespace"
  name      = var.namespace
  is_create = var.is_create_namespace
}

module "localstack" {
  source    = "../../modules/generic-deployment-service"
  name      = var.name
  namespace = module.namespace.name
  image     = "localstack/localstack:latest"
  ports     = [{ name = "tcp", port = 4566 }]

  env_map = {
    AWS_ACCESS_KEY_ID     = "test"
    AWS_SECRET_ACCESS_KEY = "test"
    AWS_DEFAULT_REGION    = "us-east-1"
    AWS_ENDPOINT_URL      = "http://localhost:4566"
    DOCKER_HOST          = "unix:///dind/docker.sock"
  }

  sidecars = [
    {
      name  = "dind"
      image = "docker:dind-rootless"
      args  = ["--group=1000", "--log-level=fatal"]
      env = [
        {
          name = "POD_NAME"
          value_from = {
            field_ref = {
              field_path = "metadata.name"
            }
          }
        },
        {
          name  = "DOCKER_TLS_CERTDIR"
          value = ""
        },
        {
          name  = "DOCKER_HOST"
          value = "unix:///dind/docker.sock"
        }
      ]
      security_context = {
        privileged  = true
        run_asuser  = 1000
        run_asgroup = 1000
      }

      volume_mounts = [
        {
          name       = "docker-sock"
          mount_path = "/dind"
        },
      ]
    }
  ]
  volumes = [
    {
      name = "docker-sock"
      empty_dir = {
        medium    = "Memory"
        sizeLimit = "1G"
      }
      mount_path = "/dind"
    },
  ]

}

resource "k8s_networking_k8s_io_v1_ingress" "this" {
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
              name = module.localstack.name
              port {
                number = module.localstack.ports[0].port
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
