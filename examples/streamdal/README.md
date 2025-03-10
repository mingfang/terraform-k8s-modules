
# Module `streamdal`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"streamdal"`)
* `namespace` (default `"streamdal-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.console` from `k8s`

## Child Modules
* `envoy` from [../../modules/generic-deployment-service](../../modules/generic-deployment-service)
* `envoy-config` from [../../modules/kubernetes/config-map](../../modules/kubernetes/config-map)
* `redis` from [../../modules/redis](../../modules/redis)
* `streamdal-console` from [../../modules/streamdal/console](../../modules/streamdal/console)
* `streamdal-server` from [../../modules/streamdal/server](../../modules/streamdal/server)

