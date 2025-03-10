
# Module `nfs-provisioner-empty-dir`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `allow_volume_expansion` (default `true`)
* `image` (default `"quay.io/kubernetes_incubator/nfs-provisioner"`)
* `is_default_class` (default `false`)
* `medium` (default `""`)
* `mount_options` (default `["vers=4.1","noatime"]`)
* `name` (required)
* `namespace` (default `null`)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"nfs","port":2049},{"name":"nfs-udp","port":2049,"protocol":"UDP"},{"name":"mountd","port":20048},{"name":"mountd-udp","port":20048,"protocol":"UDP"},{"name":"rpcbind","port":111},{"name":"rpcbind-udp","port":111,"protocol":"UDP"},{"name":"tcp-662","port":662},{"name":"udp-662","port":662,"protocol":"UDP"},{"name":"tcp-875","port":875},{"name":"udp-875","port":875,"protocol":"UDP"},{"name":"tcp-32803","port":32803},{"name":"udp-32803","port":32803,"protocol":"UDP"}]`)
* `reclaim_policy` (default `"Retain"`)
* `storage_class` (default `"nfs-provisioner"`)

## Output Values
* `deployment`
* `name`
* `service`
* `storage_class`

## Managed Resources
* `k8s_storage_k8s_io_v1_storage_class.this` from `k8s`

## Child Modules
* `deployment-service` from [../../archetypes/deployment-service](../../archetypes/deployment-service)
* `rbac` from [../../modules/kubernetes/rbac](../../modules/kubernetes/rbac)

