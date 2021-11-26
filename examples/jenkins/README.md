
# Module `jenkins`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"jenkins"`)
* `namespace` (default `"jenkins-example"`)
* `storage_class_name` (default `"cephfs"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_core_v1_persistent_volume_claim.this` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.this` from `k8s`

## Child Modules
* `casc_configs` from [../../modules/kubernetes/config-map](../../modules/kubernetes/config-map)
* `jenkins` from [../../modules/jenkins/jenkins](../../modules/jenkins/jenkins)

