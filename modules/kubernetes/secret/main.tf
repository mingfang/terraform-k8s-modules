terraform {
  required_providers {
    k8s = {
      source  = "mingfang/k8s"
    }
  }
}

locals {
  data = merge(
    var.from-dir != null ? { for f in fileset(var.from-dir, "*") : f => base64encode(file("${var.from-dir}/${f}")) } : {},
    var.from-files != null ? { for f in var.from-files : basename(f) => base64encode(file(f)) } : {},
    var.from-file != null ? {
      basename(var.from-file) = base64encode(file(var.from-file))
    } : {},
    var.from-map,
  )
}

resource "k8s_core_v1_secret" "this" {
  metadata {
    name      = var.name
    namespace = var.namespace
  }

  type = var.type
  data = local.data
}