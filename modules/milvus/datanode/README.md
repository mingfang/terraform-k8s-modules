
# Module `milvus/datanode`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `ETCD_ENDPOINTS` (required)
* `MINIO_ACCESS_KEY` (required)
* `MINIO_ADDRESS` (required)
* `MINIO_SECRET_KEY` (required)
* `PULSAR_ADDRESS` (required)
* `annotations` (default `{}`)
* `env` (default `[]`)
* `image` (default `"milvusdb/milvus:v2.1.2"`)
* `name` (required)
* `namespace` (required)
* `node_selector` (default `{}`)
* `overrides` (default `{}`)
* `replicas` (default `1`)
* `resources` (default `{"requests":{"cpu":"250m","memory":"64Mi"}}`)

## Output Values
* `deployment`
* `name`
* `service`

## Child Modules
* `deployment-service` from [../../../archetypes/deployment-service](../../../archetypes/deployment-service)

