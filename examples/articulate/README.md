
# Module `articulate`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"articulate"`)
* `namespace` (default `"articulate-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_extensions_v1beta1_ingress.this` from `k8s`

## Child Modules
* `api` from [../../modules/articulate/api](../../modules/articulate/api)
* `duckling` from [../../modules/articulate/duckling](../../modules/articulate/duckling)
* `elasticsearch` from [../../modules/elasticsearch](../../modules/elasticsearch)
* `elasticsearch_storage` from [../../modules/kubernetes/storage-nfs](../../modules/kubernetes/storage-nfs)
* `nfs-server` from [../../modules/nfs-server-empty-dir](../../modules/nfs-server-empty-dir)
* `nginx` from [../../modules/articulate/nginx](../../modules/articulate/nginx)
* `rasa` from [../../modules/articulate/rasa](../../modules/articulate/rasa)
* `redis` from [../../modules/redis](../../modules/redis)
* `redis_storage` from [../../modules/kubernetes/storage-nfs](../../modules/kubernetes/storage-nfs)
* `ui` from [../../modules/articulate/ui](../../modules/articulate/ui)

