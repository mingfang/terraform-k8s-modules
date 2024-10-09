
# Module `formkiq`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"formkiq"`)
* `namespace` (default `"formkiq-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_core_v1_persistent_volume_claim.dynamodb` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.this` from `k8s`

## Child Modules
* `dynamodb` from [../../modules/aws/dynamodb](../../modules/aws/dynamodb)
* `formkiq` from [../../modules/formkiq](../../modules/formkiq)
* `minio` from [../../modules/minio](../../modules/minio)

