
# Module `grafana/loki-rule`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `expr` (required)
* `name` (required)
* `namespace` (required)
* `orgId` (required)
* `service_key` (required)

## Child Modules
* `loki-rule` from [../../kubernetes/config-map](../../kubernetes/config-map)

