
# Module `trafficserver`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"trafficserver"`)
* `namespace` (default `"trafficserver-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`

## Child Modules
* `trafficserver` from [../../modules/trafficserver](../../modules/trafficserver)

