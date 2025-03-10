
# Module `kube-griffiti`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"kube-griffiti"`)
* `namespace` (default `"kube-griffiti-example"`)

## Managed Resources
* `k8s_cert_manager_io_v1alpha2_certificate.this` from `k8s`
* `k8s_core_v1_namespace.this` from `k8s`

## Child Modules
* `kube-griffiti` from [../../modules/kubernetes/kube-griffiti](../../modules/kubernetes/kube-griffiti)

