
# Module `nifi`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"nifi"`)
* `namespace` (default `"nifi-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_extensions_v1beta1_ingress.minifi-c2` from `k8s`
* `k8s_extensions_v1beta1_ingress.nifi` from `k8s`

## Child Modules
* `ingress` from [../../modules/kubernetes/ingress-nginx](../../modules/kubernetes/ingress-nginx)
* `minifi-c2` from [../../modules/nifi/minifi-c2](../../modules/nifi/minifi-c2)
* `nfs-server` from [../../modules/nfs-server-empty-dir](../../modules/nfs-server-empty-dir)
* `nifi` from [../../modules/nifi/nifi](../../modules/nifi/nifi)
* `zookeeper` from [../../modules/zookeeper](../../modules/zookeeper)
* `zookeeper-storage` from [../../modules/kubernetes/storage-nfs](../../modules/kubernetes/storage-nfs)

