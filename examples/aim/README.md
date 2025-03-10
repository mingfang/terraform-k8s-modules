
# Module `aim`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"aim"`)
* `namespace` (default `"aim-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_core_v1_persistent_volume_claim.data` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.aim-server` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.aim-ui` from `k8s`

## Child Modules
* `aim-server` from [../../modules/aim/aim-server](../../modules/aim/aim-server)
* `aim-ui` from [../../modules/aim/aim-ui](../../modules/aim/aim-ui)

