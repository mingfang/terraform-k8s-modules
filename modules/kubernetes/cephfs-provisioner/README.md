
# Module `kubernetes/cephfs-provisioner`

Provider Requirements:
* **k8s (`mingfang/k8s`):** (any version)

## Input Variables
* `PROVISIONER_NAME` (default `"ceph.com/cephfs"`)
* `image` (default `"quay.io/external_storage/cephfs-provisioner:latest"`)
* `name` (default `"cephfs-provisioner"`)
* `namespace` (default `"kube-system"`)
* `overrides` (default `{}`)

## Output Values
* `deployment`
* `name`
* `provisioner`
* `service`

## Child Modules
* `deployment-service` from [../../../archetypes/deployment-service](../../../archetypes/deployment-service)
* `rbac` from [../rbac](../rbac)

