
# Module `pulsar/sql`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `EXTRA_OPTS` (default `""`)
* `PULSAR_MEM` (default `"-Xms64m -Xmx128m -XX:MaxDirectMemorySize=128m"`)
* `discovery_uri` (default `""`)
* `image` (default `"apachepulsar/pulsar-all:2.10.0"`)
* `name` (required)
* `namespace` (default `null`)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":8081}]`)
* `pulsar` (required)
* `replicas` (default `1`)
* `zookeeper` (required)

## Output Values
* `deployment`
* `name`
* `service`

## Child Modules
* `deployment-service` from `git::https://github.com/mingfang/terraform-k8s-modules.git//archetypes/deployment-service`

