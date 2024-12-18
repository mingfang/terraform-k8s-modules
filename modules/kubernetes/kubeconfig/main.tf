/*
This may fail the first time because the it may take a few seconds for the data to be available
*/
resource "local_file" "kubeconfig" {
  filename = "${var.name}-${var.cluster}-kubeconfig"
  content  = <<-EOF
    apiVersion: v1
    kind: Config

    clusters:
    - name: ${var.cluster}
      cluster:
        certificate-authority-data: ${k8s_core_v1_secret.this.data["ca.crt"]}
        server: ${var.server}

    contexts:
    - name: default-context
      context:
        cluster: ${var.cluster}
        namespace: ${var.namespace}
        user: ${var.name}
    current-context: default-context

    users:
    - name: ${var.name}
      user:
        token: ${base64decode(k8s_core_v1_secret.this.data["token"])}
    EOF
}
