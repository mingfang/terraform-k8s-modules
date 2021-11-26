
# Module `cassandra`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `CASSANDRA_CLUSTER_NAME` (default `"cassandra"`)
* `CASSANDRA_DC` (default `"dc1"`)
* `CASSANDRA_ENDPOINT_SNITCH` (default `"GossipingPropertyFileSnitch"`)
* `CASSANDRA_RACK` (default `"rack1"`)
* `annotations` (default `{}`)
* `env` (default `[]`)
* `image` (default `"cassandra:3.11.8"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"intra-node","port":7000},{"name":"intra-node-tls","port":7001},{"name":"jmx","port":7199},{"name":"rpc","port":9160},{"name":"cql","port":9042}]`)
* `replicas` (default `1`)
* `resources` (default `{"limits":{"memory":"1Gi"},"requests":{"cpu":"500m","memory":"512Mi"}}`)
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

