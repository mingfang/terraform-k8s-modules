resource "k8s_storage_k8s_io_v1_csi_driver" "this" {

  metadata {
    name        = "ru.yandex.s3.csi"
  }

  spec {
    attach_required    = "false"
    pod_info_onmount   = "true"
  }
}
