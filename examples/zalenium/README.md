
# Module `zalenium`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"zalenium"`)
* `namespace` (default `"zalenium-example"`)
* `storage_class_name` (default `"cephfs"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_core_v1_persistent_volume_claim.this` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.this` from `k8s`

## Child Modules
* `hub` from [../../modules/zalenium](../../modules/zalenium)
* `user_secret` from [../../modules/kubernetes/secret](../../modules/kubernetes/secret)

