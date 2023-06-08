
# Module `spark`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"spark"`)
* `namespace` (default `"spark-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_core_v1_persistent_volume_claim.data` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.ui-proxy` from `k8s`

## Child Modules
* `master` from [../../modules/spark/master](../../modules/spark/master)
* `ui-proxy` from [../../modules/spark/ui-proxy](../../modules/spark/ui-proxy)
* `worker` from [../../modules/spark/worker](../../modules/spark/worker)

