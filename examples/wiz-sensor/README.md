
# Module `wiz-sensor`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"wiz-sensor"`)
* `namespace` (default `"wiz-sensor"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`

## Child Modules
* `api-client-secret` from [../../../terraform-k8s-modules/modules/kubernetes/secret](../../../terraform-k8s-modules/modules/kubernetes/secret)
* `image_pull_secret` from [../../../terraform-k8s-modules/modules/kubernetes/secret](../../../terraform-k8s-modules/modules/kubernetes/secret)
* `wiz-sensor` from [../../modules/generic-daemonset](../../modules/generic-daemonset)

