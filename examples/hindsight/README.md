
# Module `hindsight`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `hindsight_litellm_api_base` (required)
* `hindsight_litellm_api_key` (required)
* `hindsight_llm_api_key` (required)
* `hindsight_llm_base_url` (required)
* `is_create_namespace` (default `true`)
* `name` (default `"hindsight"`)
* `namespace` (default `"hindsight-example"`)
* `otel_exporter_endpoint` (required)
* `otel_exporter_headers` (required)
* `postgres_password` (required)
* `postgres_user` (required)
* `s3_access_key_id` (required)
* `s3_bucket` (required)
* `s3_secret_access_key` (required)

## Managed Resources
* `k8s_networking_k8s_io_v1_ingress.admin` from `k8s`

## Child Modules
* `hindsight` from [../../modules/generic-deployment-service](../../modules/generic-deployment-service)
* `hindsight-db` from [../../modules/cloudnative-pg-cluster](../../modules/cloudnative-pg-cluster)
* `hindsight-worker` from [../../modules/generic-statefulset-service](../../modules/generic-statefulset-service)
* `namespace` from [../namespace](../namespace)

