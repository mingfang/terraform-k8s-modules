
# Module `kafka`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"kafka"`)
* `namespace` (default `"kafka-example"`)
* `replicas` (default `3`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`

## Child Modules
* `kafka` from [../../modules/kafka](../../modules/kafka)
* `zookeeper` from [../../modules/zookeeper](../../modules/zookeeper)

