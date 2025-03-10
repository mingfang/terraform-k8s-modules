
# Module `confluentinc`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"confluentinc"`)
* `namespace` (default `"confluentinc-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.control-center` from `k8s`

## Child Modules
* `connect` from [../../modules/confluentinc/connect](../../modules/confluentinc/connect)
* `control-center` from [../../modules/confluentinc/control-center](../../modules/confluentinc/control-center)
* `kafka` from [../../modules/confluentinc/kafka](../../modules/confluentinc/kafka)
* `ksqldb-server` from [../../modules/confluentinc/ksqldb-server](../../modules/confluentinc/ksqldb-server)
* `schema-registry` from [../../modules/confluentinc/schema-registry](../../modules/confluentinc/schema-registry)
* `zookeeper` from [../../modules/zookeeper](../../modules/zookeeper)

