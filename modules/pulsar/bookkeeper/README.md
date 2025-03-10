
# Module `pulsar/bookkeeper`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `EXTRA_OPTS` (default `""`)
* `PULSAR_MEM` (default `"-Xms64m -Xmx256m -XX:MaxDirectMemorySize=256m"`)
* `clusterName` (default `"local"`)
* `dbStorage_readAheadCacheMaxSizeMb` (default `32`)
* `dbStorage_writeCacheMaxSizeMb` (default `32`)
* `image` (default `"apachepulsar/pulsar-all:2.10.0"`)
* `name` (required)
* `namespace` (default `null`)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"bookie","port":3181}]`)
* `replicas` (default `3`)
* `storage` (required)
* `storage_class` (required)
* `zookeeper` (required)

## Output Values
* `name`
* `service`
* `statefulset`

## Child Modules
* `statefulset-service` from `git::https://github.com/mingfang/terraform-k8s-modules.git//archetypes/statefulset-service`

