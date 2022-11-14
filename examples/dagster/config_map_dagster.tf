module "config_map_dagster" {
  source    = "../../modules/kubernetes/config-map"
  name      = "${var.name}-dagster"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  from-file = "${path.module}/dagster.yaml"
}