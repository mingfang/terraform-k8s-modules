
# Module `debezium-mysql-elasticsearch`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)
* **template:** (any version)

## Input Variables
* `ingress_host` (default `"192.168.2.146"`)
* `name` (default `"debezium-mysql-es"`)
* `namespace` (default `"debezium-mysql-es"`)
* `node_port_http` (default `"30090"`)
* `node_port_https` (default `"30091"`)
* `topics` (default `"customers"`)

## Output Values
* `urls`

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`

## Data Resources
* `data.template_file.sink` from `template`
* `data.template_file.source` from `template`

## Child Modules
* `debezium` from [../../solutions/debezium](../../solutions/debezium)
* `elasticsearch` from [../../modules/elasticsearch](../../modules/elasticsearch)
* `elasticsearch_storage` from [../../modules/kubernetes/storage-nfs](../../modules/kubernetes/storage-nfs)
* `ingress-controller` from [../../modules/kubernetes/ingress-nginx](../../modules/kubernetes/ingress-nginx)
* `ingress-rules` from [../../modules/kubernetes/ingress-rules](../../modules/kubernetes/ingress-rules)
* `job_sink` from [../../solutions/debezium/job](../../solutions/debezium/job)
* `job_source` from [../../solutions/debezium/job](../../solutions/debezium/job)
* `kafka_storage` from [../../modules/kubernetes/storage-nfs](../../modules/kubernetes/storage-nfs)
* `mysql` from `./mysql`
* `nfs-server` from [../../modules/nfs-server-empty-dir](../../modules/nfs-server-empty-dir)
* `zookeeper_storage` from [../../modules/kubernetes/storage-nfs](../../modules/kubernetes/storage-nfs)

