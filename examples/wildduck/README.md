
# Module `wildduck`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)
* **random:** (any version)

## Input Variables
* `name` (default `"wildduck"`)
* `namespace` (default `"wildduck-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.api` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.mongo-express` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.webmail` from `k8s`
* `random_password.keyfile` from `random`

## Child Modules
* `config` from [../../modules/kubernetes/config-map](../../modules/kubernetes/config-map)
* `mongo-express` from [../../modules/mongo-express](../../modules/mongo-express)
* `mongodb` from [../../modules/mongodb](../../modules/mongodb)
* `redis` from [../../modules/redis](../../modules/redis)
* `secret` from [../../modules/kubernetes/secret](../../modules/kubernetes/secret)
* `wildduck` from [../../modules/wildduck](../../modules/wildduck)
* `wildduck-webmail` from [../../modules/wildduck-webmail](../../modules/wildduck-webmail)

