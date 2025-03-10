
# Module `kubernetes/efs-provisioner`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `AWS_REGION` (default `null`): set if using standard DNS name, e.g. *file-system-id*.efs.*aws-region*.amazonaws.com
* `DNS_NAME` (default `null`): set if using custom DNS name
* `FILE_SYSTEM_ID` (default `null`): set if using standard DNS name, e.g. *file-system-id*.efs.*aws-region*.amazonaws.com
* `PROVISIONER_NAME` (default `"amazon.com/aws-efs"`)
* `image` (default `"quay.io/external_storage/efs-provisioner:latest"`)
* `name` (default `"efs-provisioner"`)
* `namespace` (default `"kube-system"`)
* `overrides` (default `{}`)

## Output Values
* `deployment`
* `name`
* `provisioner`
* `service`

## Managed Resources
* `k8s_core_v1_secret.kubernetes-dashboard-certs` from `k8s`

## Child Modules
* `deployment-service` from [../../../archetypes/deployment-service](../../../archetypes/deployment-service)
* `rbac` from [../rbac](../rbac)

