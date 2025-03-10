resource "k8s_core_v1_service_account" "ebs_csi_controller_sa" {
  metadata {
    labels = {
      "app.kubernetes.io/name" = "aws-ebs-csi-driver"
    }
    name      = "ebs-csi-controller-sa"
    namespace = var.namespace
  }
}