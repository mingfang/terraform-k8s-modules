
# Module `deephaven`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"deephaven"`)
* `namespace` (default `"deephaven-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_core_v1_persistent_volume_claim.data` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.this` from `k8s`

## Child Modules
* `envoy` from [../../modules/deephaven/envoy](../../modules/deephaven/envoy)
* `grpc-proxy` from [../../modules/deephaven/grpc-proxy](../../modules/deephaven/grpc-proxy)
* `server` from [../../modules/deephaven/server](../../modules/deephaven/server)
* `web` from [../../modules/deephaven/web](../../modules/deephaven/web)

