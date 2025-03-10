
# Module `aws/aws-ebs-csi`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `namespace` (default `"kube-system"`)

## Managed Resources
* `k8s_apps_v1_daemon_set.ebs_csi_node` from `k8s`
* `k8s_apps_v1_deployment.ebs_csi_controller` from `k8s`
* `k8s_core_v1_service_account.ebs_csi_controller_sa` from `k8s`
* `k8s_rbac_authorization_k8s_io_v1_cluster_role.ebs_external_attacher_role` from `k8s`
* `k8s_rbac_authorization_k8s_io_v1_cluster_role.ebs_external_provisioner_role` from `k8s`
* `k8s_rbac_authorization_k8s_io_v1_cluster_role_binding.ebs_csi_attacher_binding` from `k8s`
* `k8s_rbac_authorization_k8s_io_v1_cluster_role_binding.ebs_csi_provisioner_binding` from `k8s`
* `k8s_storage_k8s_io_v1beta1_csi_driver.ebs_csi_aws_com` from `k8s`

