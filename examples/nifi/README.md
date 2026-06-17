
# Module `nifi`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"nifi"`)
* `namespace` (default `"nifi-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_networking_k8s_io_v1_ingress.nifi` from `k8s`

## Child Modules
* `nifi` from [../../modules/nifi/nifi](../../modules/nifi/nifi)
* `zookeeper` from [../../modules/zookeeper](../../modules/zookeeper)

