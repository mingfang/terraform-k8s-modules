resource "k8s_storage_k8s_io_v1_storage_class" "this" {
  metadata {
    name = var.name
  }

  _provisioner = "ru.yandex.s3.csi"
  parameters = {
    mounter                                                  = "geesefs"
    # you can set mount options here, for example limit memory cache size (recommended)
    options                                                  = "--memory-limit 1000 --dir-mode 0777 --file-mode 0666"
    # to use an existing bucket, specify it here:
    #bucket: some-existing-bucket
    "csi.storage.k8s.io/provisioner-secret-name"             = var.secret_name
    "csi.storage.k8s.io/provisioner-secret-namespace"        = var.namespace
    "csi.storage.k8s.io/controller-publish-secret-name"      = var.secret_name
    "csi.storage.k8s.io/controller-publish-secret-namespace" = var.namespace
    "csi.storage.k8s.io/node-stage-secret-name"              = var.secret_name
    "csi.storage.k8s.io/node-stage-secret-namespace"         = var.namespace
    "csi.storage.k8s.io/node-publish-secret-name"            = var.secret_name
    "csi.storage.k8s.io/node-publish-secret-namespace"       = var.namespace
  }
}
