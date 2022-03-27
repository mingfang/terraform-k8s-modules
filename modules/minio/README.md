
# Module `minio`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `annotations` (default `{}`)
* `args` (default `[]`)
* `create_buckets` (default `[]`)
* `env` (default `[]`)
* `image` (default `"minio/minio:RELEASE.2021-08-25T00-41-18Z.hotfix.fa57120f2"`)
* `minio_access_key` (required)
* `minio_secret_key` (required)
* `name` (required)
* `namespace` (required)
* `node_selector` (default `null`)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":9000},{"name":"http-console","port":9001}]`)
* `replicas` (default `1`)
* `storage` (required)
* `storage_class_name` (required)
* `volume_claim_template_name` (default `"pvc"`)

## Output Values
* `name`
* `ports`
* `service`
* `statefulset`

## Child Modules
* `init-job` from [../kubernetes/job](../kubernetes/job)
* `statefulset-service` from [../../archetypes/statefulset-service](../../archetypes/statefulset-service)

