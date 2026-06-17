resource "k8s_core_v1_namespace" "this" {
  metadata {
    labels = {
      "istio-injection" = "disabled"
    }

    name = "jitsi-example"
  }
}

# Frontend
module "web" {
  source    = "../../modules/jitsi/web"
  name      = "web"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  ENABLE_AUTH        = "0"
  XMPP_BOSH_URL_BASE = "http://${module.prosody.name}:5280"
}

/*
Depends on an Ingress Controller with Cert-Manager and LetsEncrypt
*/
resource "k8s_networking_k8s_io_v1_ingress" "web" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"       = "nginx"
      "certmanager.k8s.io/cluster-issuer" = "letsencrypt-prod"
    }
    name      = module.web.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    ingress_class_name = "nginx"
    rules {
      host = var.NAT_HARVESTER_PUBLIC_ADDRESS
      http {
        paths {
          backend {
            service {
              name = module.web.name
              port {
                number = "80"
              }
            }
          }
          path      = "/"
          path_type = "ImplementationSpecific"
        }
      }
    }

    tls {
      hosts = [
        var.NAT_HARVESTER_PUBLIC_ADDRESS
      ]
      secret_name = "meet-tls"
    }

  }
}

# Focus component
module "jicofo" {
  source    = "../../modules/jitsi/jicofo"
  name      = "jicofo"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  ENABLE_AUTH = "0"
  XMPP_SERVER = module.prosody.name
}

# XMPP server
module "prosody" {
  source    = "../../modules/jitsi/prosody"
  name      = "prosody"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  ENABLE_AUTH = "0"
}

# Video bridges
module "jvb" {
  source    = "../../modules/jitsi/jvb"
  name      = "jvb"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  XMPP_SERVER = module.prosody.name
  // advertise NAT address
  NAT_HARVESTER_PUBLIC_ADDRESS = var.NAT_HARVESTER_PUBLIC_ADDRESS
  // fallback to TCP when UDP fails
  JVB_TCP_HARVESTER_DISABLED = "false"
}

//todo: move this into the jvb module?
resource "k8s_core_v1_service" "jvb-udp" {
  metadata {
    name      = "jvb-udp"
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {

    ports {
      name     = "udp"
      port     = 10000
      protocol = "UDP"
    }
    selector         = module.jvb.service.spec.0.selector
    load_balancer_ip = var.load_balancer_ip
    type             = "LoadBalancer"
  }
}
