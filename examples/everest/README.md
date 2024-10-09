
# Module `everest`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"everest"`)
* `namespace` (default `"everest-system"`)

## Managed Resources
* `k8s_core_v1_namespace.everest` from `k8s`
* `k8s_core_v1_namespace.everest-system` from `k8s`
* `k8s_networking_k8s_io_v1_ingress.everest` from `k8s`

## Child Modules
* `accounts` from [../../modules/kubernetes/secret](../../modules/kubernetes/secret)
* `everest` from [../../modules/generic-deployment-service](../../modules/generic-deployment-service)
* `everest-rbac` from [../../modules/kubernetes/config-map](../../modules/kubernetes/config-map)
* `secrets` from [../../modules/kubernetes/secret](../../modules/kubernetes/secret)

