
# Module `spice`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"spice"`)
* `namespace` (default `"spice-example"`)

## Managed Resources
* `k8s_core_v1_namespace.spice` from `k8s`
* `k8s_networking_k8s_io_v1_ingress.spice` from `k8s`

## Child Modules
* `spice` from [../../modules/generic-deployment-service](../../modules/generic-deployment-service)
* `spice-config` from [../../modules/kubernetes/config-map](../../modules/kubernetes/config-map)

