
# Module `spring-dataflow`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"spring-dataflow"`)
* `namespace` (default `"spring-dataflow-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.dataflow` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.management` from `k8s`

## Child Modules
* `dataflow-server` from [../../modules/spring-dataflow/dataflow-server](../../modules/spring-dataflow/dataflow-server)
* `mysql-dataflow` from [../../modules/mysql](../../modules/mysql)
* `mysql-skipper` from [../../modules/mysql](../../modules/mysql)
* `rabbitmq` from [../../modules/rabbitmq](../../modules/rabbitmq)
* `skipper-server` from [../../modules/spring-dataflow/skipper-server](../../modules/spring-dataflow/skipper-server)

