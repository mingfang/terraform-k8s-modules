locals {
  expr = replace(var.expr, "\n", "")
}

module "loki-rule" {
  source    = "../../kubernetes/config-map"
  name      = var.name
  namespace = var.namespace
  labels = {
    "loki-rules" = "true"
  }
  annotations = {
    "k8s-sidecar-target-directory" = "/tmp/data/${var.orgId}"
  }
  from-map = {
    "rule" = <<-EOF
      groups:
      - name: ${var.name}
        rules:
        - alert: ${var.name}
          expr: >-
            sum by (job, log) (rate(${local.expr} |regexp "(?P<log>.*)" [1m])) > 0
          for: 0s
          labels:
            severity: warning
          annotations:
            orgId: ${var.orgId}
            expr: >-
              ${replace(urlencode(replace(local.expr, "\"", "\\\"")), "+", "%20")}
            timestamp: now
            service_key: ${var.service_key}
      EOF
  }
}
