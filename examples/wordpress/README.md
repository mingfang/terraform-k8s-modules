
# Module `wordpress`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"wordpress"`)
* `namespace` (default `"wordpress-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_extensions_v1beta1_ingress.wordpress` from `k8s`

## Child Modules
* `mysql` from [../../modules/mysql](../../modules/mysql)
* `mysql-storage` from [../../modules/kubernetes/storage-nfs](../../modules/kubernetes/storage-nfs)
* `nfs-server` from [../../modules/nfs-server-empty-dir](../../modules/nfs-server-empty-dir)
* `wordpress` from [../../modules/wordpress](../../modules/wordpress)

