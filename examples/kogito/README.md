
# Module `kogito`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"kogito"`)
* `namespace` (default `"kogito-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.console` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.data-index` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.infinispan` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.jit-runner` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.task-console` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.travels` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.trusty-ui` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.visas` from `k8s`

## Child Modules
* `data-index` from [../../modules/kogito/data-index](../../modules/kogito/data-index)
* `data-index-protobufs` from [../../modules/kubernetes/config-map](../../modules/kubernetes/config-map)
* `explainability` from [../../modules/kogito/explainability](../../modules/kogito/explainability)
* `infinispan` from [../../modules/infinispan](../../modules/infinispan)
* `jit-runner` from [../../modules/kogito/jit-runner](../../modules/kogito/jit-runner)
* `jobs-service` from [../../modules/kogito/jobs-service](../../modules/kogito/jobs-service)
* `kafka` from [../../modules/confluentinc/kafka](../../modules/confluentinc/kafka)
* `management-console` from [../../modules/kogito/management-console](../../modules/kogito/management-console)
* `task-console` from [../../modules/kogito/task-console](../../modules/kogito/task-console)
* `travels` from [../../modules/kogito/jit-runner](../../modules/kogito/jit-runner)
* `trusty` from [../../modules/kogito/trusty](../../modules/kogito/trusty)
* `trusty-ui` from [../../modules/kogito/trusty-ui](../../modules/kogito/trusty-ui)
* `visas` from [../../modules/kogito/jit-runner](../../modules/kogito/jit-runner)
* `zookeeper` from [../../modules/zookeeper](../../modules/zookeeper)

