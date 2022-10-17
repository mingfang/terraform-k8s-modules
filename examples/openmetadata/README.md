
# Module `openmetadata`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"openmetadata"`)
* `namespace` (default `"openmetadata-example"`)
* `replicas` (default `1`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_core_v1_persistent_volume_claim.ingestion` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.ingestion` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.this` from `k8s`

## Child Modules
* `elasticsearch` from [../../modules/elasticsearch](../../modules/elasticsearch)
* `ingestion` from [../../modules/openmetadata/ingestion](../../modules/openmetadata/ingestion)
* `postgres` from [../../modules/postgres](../../modules/postgres)
* `server` from [../../modules/openmetadata/server](../../modules/openmetadata/server)

