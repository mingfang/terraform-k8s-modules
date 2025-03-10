
# Module `pulsar`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"pulsar"`)
* `namespace` (default `"pulsar-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_extensions_v1beta1_ingress.pulsar-dashboard` from `k8s`
* `k8s_extensions_v1beta1_ingress.pulsar-proxy` from `k8s`
* `k8s_extensions_v1beta1_ingress.pulsar-sql-coordinator` from `k8s`
* `k8s_extensions_v1beta1_ingress.pulsar-websocket` from `k8s`

## Child Modules
* `bookkeeper` from [../../modules/pulsar/bookkeeper](../../modules/pulsar/bookkeeper)
* `pulsar` from [../../modules/pulsar/broker](../../modules/pulsar/broker)
* `pulsar-dashboard` from [../../modules/pulsar/dashboard](../../modules/pulsar/dashboard)
* `pulsar-proxy` from [../../modules/pulsar/proxy](../../modules/pulsar/proxy)
* `pulsar-sql-coordinator` from [../../modules/pulsar/sql](../../modules/pulsar/sql)
* `pulsar-sql-worker` from [../../modules/pulsar/sql](../../modules/pulsar/sql)
* `pulsar-websocket` from [../../modules/pulsar/websocket](../../modules/pulsar/websocket)
* `zookeeper` from [../../modules/zookeeper](../../modules/zookeeper)

