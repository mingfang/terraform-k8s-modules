resource "k8s_core_v1_config_map" "this" {
  metadata {
    name      = var.name
    namespace = var.namespace
  }

  data = merge(
    var.from-dir != null ? { for f in fileset(var.from-dir, "*") : f => file("${var.from-dir}/${f}") } : {},
    var.from-file != null ? { basename(var.from-file) = file(var.from-file) } : {},
    var.from-map,
  )
}