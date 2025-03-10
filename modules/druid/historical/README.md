
# Module `druid/historical`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `annotations` (default `{}`)
* `druid_extensions_loadList` (default `[]`): A JSON array of extensions to load from extension directories by Druid. If it is not specified, its value will be null and Druid will load all the extensions under druid.extensions.directory. If its value is empty list [], then no extensions will be loaded at all. It is also allowed to specify absolute path of other custom extensions not stored in the common extensions directory.
* `druid_metadata_storage_connector_connectURI` (default `null`): The JDBC URI for the database to connect to
* `druid_metadata_storage_connector_password` (default `null`): The Password Provider or String password used to connect with.
* `druid_metadata_storage_connector_user` (default `null`): The username to connect with.
* `druid_metadata_storage_type` (default `"derby"`): The type of metadata storage to use. Choose from "mysql", "postgresql", or "derby".
* `druid_zk_service_host` (required)
* `env` (default `[]`)
* `image` (default `"apache/druid:0.21.0"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"tcp","port":8083}]`)
* `replicas` (default `1`)
* `resources` (default `{"requests":{"cpu":"500m","memory":"2Gi"}}`)
* `storage` (required)
* `storage_class` (required)
* `volume_claim_template_name` (default `"pvc"`)

## Output Values
* `name`
* `ports`
* `service`
* `statefulset`

## Child Modules
* `statefulset-service` from [../../../archetypes/statefulset-service](../../../archetypes/statefulset-service)

