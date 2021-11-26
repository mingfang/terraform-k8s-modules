
# Module `metron`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `ingress-ip` (default `"192.168.2.146"`)
* `ingress-node-port` (default `"30080"`)
* `minio_access_key` (default `"IUWU60H2527LP7DOYJVP"`)
* `minio_secret_key` (default `"bbdGponYV5p9P99EsasLSu4K3SjYBEcBLtyz7wbm"`)
* `name` (default `"minio"`)
* `namespace` (default `"minio"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`

## Child Modules
* `metro` from [../../modules/metron](../../modules/metron)

