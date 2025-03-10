
# Module `neon/pageserver`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `BROKER_ENDPOINT` (required): http://storage_broker:50051
* `BUCKET_NAME` (default `"neon"`)
* `BUCKET_PREFIX` (default `"pageserver"`)
* `BUCKET_REGION` (default `"us-east-1"`)
* `S3_ENDPOINT` (default `""`): http://minio:9000
* `annotations` (default `{}`)
* `args` (default `[]`)
* `command` (default `[]`)
* `configmap` (default `null`)
* `configmap_mount_path` (default `"/config"`)
* `env` (default `[]`)
* `env_file` (default `null`)
* `env_from` (default `[]`)
* `env_map` (default `{}`)
* `image` (default `"neondatabase/neon:latest"`)
* `mount_path` (default `"/data"`): pvc mount path
* `name` (default `"pageserver"`)
* `namespace` (required)
* `node_selector` (default `{}`)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":8080},{"name":"postgres","port":5432}]`)
* `post_start_command` (default `null`)
* `replicas` (default `1`)
* `resources` (default `{"requests":{"cpu":"250m","memory":"64Mi"}}`)
* `service_account_name` (default `null`)
* `storage` (default `null`)
* `storage_class` (default `null`)
* `volume_claim_template_name` (default `"pvc"`)

## Output Values
* `name`
* `ports`
* `service`
* `statefulset`

## Child Modules
* `statefulset-service` from [../../../archetypes/statefulset-service](../../../archetypes/statefulset-service)

