locals {
  env = merge(
    var.from-file != null ? { for tuple in regexall("(\\w+)=(.+)", file(var.from-file)) : tuple[0] => tuple[1] } : {},
    var.from-map,
  )
  kubernetes_env = [for k, v in local.env : { name = k, value = v }]
}
