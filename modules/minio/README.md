
# Module `minio`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `annotations` (default `{}`)
* `args` (default `[]`)
* `create_buckets` (default `[]`)
* `env` (default `[]`)
* `env_file` (default `null`)
* `env_from` (default `[]`)
* `env_map` (default `{}`)
* `image` (default `"minio/minio:RELEASE.2021-08-05T22-01-19Z"`)
* `minio_access_key` (default `null`)
* `minio_secret_key` (default `null`)
* `name` (required)
* `namespace` (required)
* `node_selector` (default `{}`)
* `overrides` (default `{}`)
* `policies_configmap` (default `null`)
* `ports` (default `[{"name":"http","port":9000},{"name":"http-console","port":9001}]`)
* `replicas` (default `1`)
* `resources` (default `{"requests":{"cpu":"250m","memory":"64Mi"}}`)
* `service_account_name` (default `null`)
* `storage` (default `null`)
* `storage_class_name` (default `null`)
* `volume_claim_template_name` (default `"pvc"`)

## Output Values
* `name`
* `ports`
* `service`
* `statefulset`

## Child Modules
* `init-job` from [../kubernetes/job](../kubernetes/job)
* `statefulset-service` from [../../archetypes/statefulset-service](../../archetypes/statefulset-service)

