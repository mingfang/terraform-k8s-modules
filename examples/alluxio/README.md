
# Module `alluxio`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"alluxio"`)
* `namespace` (default `"alluxio-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_core_v1_persistent_volume_claim.this` from `k8s`
* `k8s_extensions_v1beta1_ingress.master` from `k8s`

## Child Modules
* `csi` from [../../modules/alluxio/csi](../../modules/alluxio/csi)
* `deployment-service` from [../../archetypes/deployment-service](../../archetypes/deployment-service)
* `ingress` from [../../modules/kubernetes/ingress-nginx](../../modules/kubernetes/ingress-nginx)
* `master` from [../../modules/alluxio/master](../../modules/alluxio/master)
* `storage-class` from [../../modules/alluxio/csi/storage-class](../../modules/alluxio/csi/storage-class)
* `worker` from [../../modules/alluxio/worker](../../modules/alluxio/worker)

