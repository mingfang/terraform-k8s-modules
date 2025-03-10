
# Module `milvus`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `minio_access_key` (default `"IUWU60H2527LP7DOYJVP"`)
* `minio_secret_key` (default `"bbdGponYV5p9P99EsasLSu4K3SjYBEcBLtyz7wbm"`)
* `name` (default `"milvus"`)
* `namespace` (default `"milvus-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.attu` from `k8s`

## Child Modules
* `attu` from [../../modules/milvus/attu](../../modules/milvus/attu)
* `datacoord` from [../../modules/milvus/datacoord](../../modules/milvus/datacoord)
* `datanode` from [../../modules/milvus/datanode](../../modules/milvus/datanode)
* `etcd` from [../../modules/etcd](../../modules/etcd)
* `indexcoord` from [../../modules/milvus/indexcoord](../../modules/milvus/indexcoord)
* `indexnode` from [../../modules/milvus/indexnode](../../modules/milvus/indexnode)
* `minio` from [../../modules/minio](../../modules/minio)
* `proxy` from [../../modules/milvus/proxy](../../modules/milvus/proxy)
* `pulsar` from [../../modules/pulsar-standalone](../../modules/pulsar-standalone)
* `querycoord` from [../../modules/milvus/querycoord](../../modules/milvus/querycoord)
* `querynode` from [../../modules/milvus/querynode](../../modules/milvus/querynode)
* `rootcoord` from [../../modules/milvus/rootcoord](../../modules/milvus/rootcoord)

