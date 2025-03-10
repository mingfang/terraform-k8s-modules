resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "ingress" {
  source        = "../../modules/kubernetes/ingress-nginx"
  name          = var.name
  namespace     = k8s_core_v1_namespace.this.metadata[0].name
  ingress_class = "nginx-example"

  // this is needed to MetaLB
  service_type     = "LoadBalancer"
  load_balancer_ip = "192.168.2.249"

  extra_args = [
    "--enable-ssl-passthrough",
    "--default-ssl-certificate=default/rebelsoft-com-tls",
  ]

  config_map_data = {
    "use-proxy-protocol"           = "true"
    "enable-modsecurity"           = "true"
    "enable-owasp-modsecurity-crs" = "true"
    "http-snippet"=<<-EOF
      ssi on;
    EOF
  }

  tcp_services_data = {
    "25565" = "minecraft/bungeecord:25565",
  }
}
