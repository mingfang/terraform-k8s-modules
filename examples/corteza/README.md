
# Module `corteza`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_extensions_v1beta1_ingress.compose` from `k8s`
* `k8s_extensions_v1beta1_ingress.messaging` from `k8s`
* `k8s_extensions_v1beta1_ingress.system` from `k8s`
* `k8s_extensions_v1beta1_ingress.webapp` from `k8s`

## Child Modules
* `compose` from [../../modules/corteza/compose](../../modules/corteza/compose)
* `database` from [../../modules/mysql](../../modules/mysql)
* `ingress` from [../../modules/kubernetes/ingress-nginx](../../modules/kubernetes/ingress-nginx)
* `messaging` from [../../modules/corteza/messaging](../../modules/corteza/messaging)
* `nfs-provisioner` from [../../modules/nfs-provisioner-empty-dir](../../modules/nfs-provisioner-empty-dir)
* `system` from [../../modules/corteza/system](../../modules/corteza/system)
* `webapp` from [../../modules/corteza/webapp](../../modules/corteza/webapp)

