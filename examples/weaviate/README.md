
# Module `weaviate`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"weaviate"`)
* `namespace` (default `"weaviate-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.this` from `k8s`

## Child Modules
* `contextionary` from [../../modules/weaviate/contextionary](../../modules/weaviate/contextionary)
* `t2v-transformers` from [../../modules/weaviate/t2v-transformers](../../modules/weaviate/t2v-transformers)
* `weaviate` from [../../modules/weaviate/weaviate](../../modules/weaviate/weaviate)

