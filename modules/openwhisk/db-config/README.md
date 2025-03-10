
# Module `openwhisk/db-config`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `db_host` (required): openwhisk-couchdb.default.svc.cluster.local
* `db_port` (required): 5984
* `name` (default `"openwhisk-db.config"`)
* `namespace` (required)

## Output Values
* `name`

## Child Modules
* `config` from [../../kubernetes/config-map](../../kubernetes/config-map)

