resource "k8s_rbac_authorization_k8s_io_v1_cluster_role_binding" "ebs_csi_provisioner_binding" {
  metadata {
    labels = {
      "app.kubernetes.io/name" = "aws-ebs-csi-driver"
    }
    name = "ebs-csi-provisioner-binding"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "ebs-external-provisioner-role"
  }

  subjects {
    kind      = "ServiceAccount"
    name      = "ebs-csi-controller-sa"
    namespace = var.namespace
  }
}