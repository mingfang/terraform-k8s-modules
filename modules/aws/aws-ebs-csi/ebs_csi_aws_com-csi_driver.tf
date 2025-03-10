resource "k8s_storage_k8s_io_v1beta1_csi_driver" "ebs_csi_aws_com" {
  metadata {
    labels = {
      "app.kubernetes.io/name" = "aws-ebs-csi-driver"
    }
    name      = "ebs.csi.aws.com"
  }
  spec {
    attach_required  = true
    pod_info_onmount = false
  }
}