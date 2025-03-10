
# Module `postal`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)
* **tls:** (any version)

## Input Variables
* `name` (default `"postal"`)
* `namespace` (default `"postal-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.this` from `k8s`
* `tls_private_key.signing_key` from `tls`

## Child Modules
* `config` from [../../modules/kubernetes/config-map](../../modules/kubernetes/config-map)
* `mysql` from [../../modules/mysql](../../modules/mysql)
* `rabbitmq` from [../../modules/rabbitmq](../../modules/rabbitmq)
* `secret` from [../../modules/kubernetes/secret](../../modules/kubernetes/secret)
* `web` from [../../modules/postal/web](../../modules/postal/web)

