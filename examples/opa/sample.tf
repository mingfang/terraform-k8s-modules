module "podpreset" {
  source = "../../modules/kubernetes/config-map"
  name = "podpreset"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  from-map = {
    "FOO"="BAR"
  }
}
module "nginx" {
  source    = "../../modules/nginx"
  name      = "nginx"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
}
