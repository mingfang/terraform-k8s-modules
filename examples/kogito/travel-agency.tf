module "travels" {
  source    = "../../modules/kogito/jit-runner"
  name      = "travels"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  image     = "registry.rebelsoft.com/kogito-travels:latest"
  env = concat(local.env, [
  ])
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "travels" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "kogito-travels-example.*"
    }
    name      = module.travels.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${module.travels.name}-${var.namespace}"
      http {
        paths {
          backend {
            service_name = module.travels.name
            service_port = module.travels.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}

module "visas" {
  source    = "../../modules/kogito/jit-runner"
  name      = "visas"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  image     = "registry.rebelsoft.com/kogito-visas:latest"
  ports = [
    {
      name = "http"
      port = 8090
    }
  ]
  env = local.env
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "visas" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "kogito-visas-example.*"
    }
    name      = module.visas.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${module.visas.name}-${var.namespace}"
      http {
        paths {
          backend {
            service_name = module.visas.name
            service_port = module.visas.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}

/* does not require visa
curl -H "Content-Type: application/json" -H "Accept: application/json" -X POST https://kogito-travels-example.rebelsoft.com/travels -d @- << EOF
{
    "traveller" : {
        "firstName" : "John",
        "lastName" : "Doe",
        "email" : "john.doe@example.com",
        "nationality" : "American",
        "address" : {
            "street" : "main street",
            "city" : "Boston",
            "zipCode" : "10005",
            "country" : "US"
        }
    },
    "trip" : {
        "city" : "New York",
        "country" : "US",
        "begin" : "2019-12-10T00:00:00.000+02:00",
        "end" : "2019-12-15T00:00:00.000+02:00"
    }
}
EOF
*/

/* require visa
curl -H "Content-Type: application/json" -H "Accept: application/json" -X POST https://kogito-travels-example.rebelsoft.com/travels -d @- << EOF
{
    "traveller" : {
        "firstName" : "Jan",
        "lastName" : "Kowalski",
        "email" : "jan.kowalski@example.com",
        "nationality" : "Polish",
        "address" : {
            "street" : "polna",
            "city" : "Krakow",
            "zipCode" : "32000",
            "country" : "Poland"
        }
    },
    "trip" : {
        "city" : "New York",
        "country" : "US",
        "begin" : "2019-12-10T00:00:00.000+02:00",
        "end" : "2019-12-15T00:00:00.000+02:00"
    }
}
EOF
*/