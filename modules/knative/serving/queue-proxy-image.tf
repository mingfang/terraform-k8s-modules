resource "k8s_caching_internal_knative_dev_v1alpha1_image" "queue-proxy" {
  metadata {
    labels = {
      "serving.knative.dev/release" = "devel"
    }
    name      = "queue-proxy"
    namespace = "${var.namespace}"
  }
  spec = <<-JSON
    {
      "image": "gcr.io/knative-releases/github.com/knative/serving/cmd/queue@sha256:b5c759e4ea6f36ae4498c1ec794653920345b9ad7492731fb1d6087e3b95dc43"
    }
    JSON
}