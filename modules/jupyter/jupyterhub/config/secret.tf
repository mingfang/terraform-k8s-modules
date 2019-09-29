resource "k8s_core_v1_secret" "this" {
  data = {
    "proxy.token"       = "ODI5MjliYWRjMzNkZmI3YWUwYzgxZDM2MDAyMzJiNTBhMjczYzYzODI0MzZkYjBiNDFlN2YxODNhNzJjMzVlNg=="
    "hub.cookie-secret" = "YjNiMTE1YWZjYjliZjNjMjNiZmIzZGRiM2JlNGE4ZTY3MWFkZmViZWRmMzdhZjZmY2UwOTI4MGRmNGNmNGU0Mg=="
    "values.yaml"       = "YXV0aDoge30KaHViOgogIHNlcnZpY2VzOiB7fQo="
  }
  metadata {
    name      = var.name
    namespace = var.namespace
  }
  type = "Opaque"
}