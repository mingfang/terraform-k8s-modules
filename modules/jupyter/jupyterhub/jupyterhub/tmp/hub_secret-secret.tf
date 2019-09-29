resource "k8s_core_v1_secret" "hub_secret" {
  data = {
    "hub.cookie-secret" = "YzczNzQ0MGIyN2E5ZDQ3NzE1ZTcwOGEyZTA4MDc0MGFkYWEyMzlhOTBjM2IyYjYwNjk1OTJjOTM0Zjc1NzBjMQ=="
    "proxy.token"       = "MTQzYTk2NDE5OTk2NmYzNzFkZGZmZDg5MDg5NDlhMjdhZTUwYWMxY2ZiYzM0MDE2NGFmMTljYjMwMDFiYzRjYQ=="
    "values.yaml"       = "YXV0aDoge30KaHViOgogIHNlcnZpY2VzOiB7fQ=="
  }
  metadata {
    labels = {
      "app"       = "jupyterhub"
      "chart"     = "jupyterhub-0.8.2"
      "component" = "hub"
      "heritage"  = "Helm"
      "release"   = "RELEASE-NAME"
    }
    name = "hub-secret"
  }
  type = "Opaque"
}