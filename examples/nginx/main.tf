resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "nginx" {
  source    = "../../modules/nginx"
  name      = var.name
  namespace = k8s_core_v1_namespace.this.metadata[0].name
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "nginx" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"                       = "nginx"
      "nginx.ingress.kubernetes.io/server-alias"          = "${var.namespace}.*"
      "nginx.ingress.kubernetes.io/configuration-snippet" = <<-EOF
        ssi on;
        ssi_silent_errors on;
        sub_filter '<body>' '<body><!--# include virtual="/_ssi/menu.menu.svc.cluster.local:3000" -->';
        sub_filter_once on;
        proxy_set_header Accept-Encoding "";
      EOF
      "nginx.ingress.kubernetes.io/server-snippet"        = <<-EOF
        location ~ ^/_ssi/(?<target>.+) {
          resolver kube-dns.kube-system.svc.cluster.local valid=5s;
          proxy_pass http://$target?$args;
          proxy_set_header Accept-Encoding "";
        }
      EOF
    }
    name      = module.nginx.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = var.namespace
      http {
        paths {
          backend {
            service_name = module.nginx.name
            service_port = 80
          }
          path = "/"
        }
      }
    }
  }
}
