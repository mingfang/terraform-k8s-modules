
# Module `oauth2-proxy`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `client_id` (required)
* `client_secret` (required)
* `issuer_url` (required)
* `name` (default `"oauth2-proxy"`)
* `namespace` (default `"oauth2-proxy-example"`)
* `replicas` (default `1`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_networking_k8s_io_v1_ingress.this` from `k8s`

## Child Modules
* `oauth2-proxy` from [../../modules/oauth2-proxy](../../modules/oauth2-proxy)
* `redis` from [../../modules/redis](../../modules/redis)

