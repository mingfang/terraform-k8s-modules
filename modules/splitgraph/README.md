
# Module `splitgraph`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `POSTGRES_DB` (required)
* `POSTGRES_PASSWORD` (required)
* `POSTGRES_USER` (required)
* `SG_LOGLEVEL` (default `"INFO"`)
* `SG_S3_BUCKET` (default `null`)
* `SG_S3_HOST` (default `null`)
* `SG_S3_KEY` (default `null`)
* `SG_S3_PORT` (default `null`)
* `SG_S3_PWD` (default `null`)
* `SG_S3_SECURE` (default `null`)
* `annotations` (default `{}`)
* `env` (default `[]`)
* `image` (default `"splitgraph/engine:0.2.17-postgis"`)
* `name` (default `"splitgraph"`)
* `namespace` (required)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"tcp","port":5432}]`)
* `replicas` (default `1`)
* `resources` (default `{"requests":{"cpu":"100m","memory":"128Mi"}}`)
* `sgconfig` (default `null`)
* `storage` (required)
* `storage_class` (required)
* `volume_claim_template_name` (default `"pvc"`)

## Output Values
* `name`
* `ports`
* `service`
* `statefulset`

## Child Modules
* `statefulset-service` from [../../archetypes/statefulset-service](../../archetypes/statefulset-service)

