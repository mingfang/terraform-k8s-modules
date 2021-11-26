
# Module `rabbitmq`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"rabbitmq"`)
* `namespace` (default `"rabbitmq-example"`)
* `replicas` (default `3`)
* `storage` (default `"1Gi"`)
* `storage_class` (default `null`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.management` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.stomp` from `k8s`

## Child Modules
* `rabbitmq` from [../../modules/rabbitmq](../../modules/rabbitmq)

