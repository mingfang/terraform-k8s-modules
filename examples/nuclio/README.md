
# Module `nuclio`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"nuclio"`)
* `namespace` (default `"nuclio-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_core_v1_persistent_volume_claim.registry` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.dashboard` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.registry` from `k8s`

## Child Modules
* `autoscaler` from [../../modules/nuclio/autoscaler](../../modules/nuclio/autoscaler)
* `config` from [../../modules/kubernetes/config-map](../../modules/kubernetes/config-map)
* `controller` from [../../modules/nuclio/controller](../../modules/nuclio/controller)
* `dashboard` from [../../modules/nuclio/dashboard](../../modules/nuclio/dashboard)
* `dlx` from [../../modules/generic-deployment-service](../../modules/generic-deployment-service)
* `priority-class-igz-workload-medium` from [../../modules/kubernetes/priority-class](../../modules/kubernetes/priority-class)
* `registry` from [../../modules/docker-registry](../../modules/docker-registry)

