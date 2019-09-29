resource "k8s_storage_k8s_io_v1_storage_class" "this" {
  metadata {
    name = var.name
  }

  _provisioner = var._provisioner

  mount_options = var.mount_options
  parameters = {
    "alluxio.master.hostname"                          = var.master_hostname
    "alluxio.master.port"                              = var.master_port
    "alluxio.worker.data.server.domain.socket.address" = var.domain_socket
    "alluxio_path"                                     = var.alluxio_path
    "java_options"                                     = var.java_options
  }
}
