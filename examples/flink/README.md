
# Module `flink`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"flink"`)
* `namespace` (default `"flink-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.jobmanager` from `k8s`

## Child Modules
* `flink-jobmanager` from [../../modules/flink/flink-jobmanager](../../modules/flink/flink-jobmanager)
* `flink-taskmanager` from [../../modules/flink/flink-taskmanager](../../modules/flink/flink-taskmanager)

