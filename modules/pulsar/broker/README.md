
# Module `pulsar/broker`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `EXTRA_OPTS` (default `""`)
* `PF_pulsarFunctionsCluster` (default `"local"`)
* `PULSAR_MEM` (default `"-Xms64m -Xmx128m -XX:MaxDirectMemorySize=128m"`)
* `clusterName` (default `"local"`)
* `configurationStoreServers` (required)
* `functionsWorkerEnabled` (default `true`)
* `image` (default `"apachepulsar/pulsar-all:2.10.0"`)
* `managedLedgerDefaultAckQuorum` (default `1`)
* `managedLedgerDefaultEnsembleSize` (default `1`)
* `managedLedgerDefaultWriteQuorum` (default `1`)
* `name` (required)
* `namespace` (default `null`)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":8080},{"name":"pulsar","port":6650}]`)
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

