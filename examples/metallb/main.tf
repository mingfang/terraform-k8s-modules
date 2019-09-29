variable "namespace" {
  default = "metallb"
}

resource "k8s_core_v1_namespace" "this" {
  metadata {
    labels = {
      "istio-injection" = "disabled"
    }

    name = var.namespace
  }
}

module "metal-lb" {
  source    = "../../modules/metallb"
  namespace = k8s_core_v1_namespace.this.metadata.0.name
}

resource "k8s_core_v1_config_map" "this" {
  data = {
    config = <<-EOF
      address-pools:
      - name: my-ip-space
        protocol: layer2
        addresses:
        - 192.168.2.241-192.168.2.250
      EOF
  }
  metadata {
    name = "config"
    namespace = k8s_core_v1_namespace.this.metadata.0.name
  }
}