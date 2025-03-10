
# Module `pulsar/proxy`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `EXTRA_OPTS` (default `""`)
* `PULSAR_MEM` (default `"-Xms16m -Xmx64m -XX:MaxDirectMemorySize=128m"`)
* `clusterName` (default `"local"`)
* `configurationStoreServers` (required)
* `image` (default `"apachepulsar/pulsar-all:2.10.0"`)
* `name` (required)
* `namespace` (default `null`)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":8080},{"name":"pulsar","port":6650}]`)
* `replicas` (default `1`)
* `zookeeper` (required)

## Output Values
* `deployment`
* `name`
* `service`

## Child Modules
* `deployment-service` from `git::https://github.com/mingfang/terraform-k8s-modules.git//archetypes/deployment-service`

