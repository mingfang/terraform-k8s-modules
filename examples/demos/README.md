
# Module `demos`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `namespace` (default `"demos"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.astro-openblocks-demo` from `k8s`

## Child Modules
* `astro-openblocks-demo` from [../../modules/generic-deployment-service](../../modules/generic-deployment-service)

