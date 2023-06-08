module "image_pull_secret" {
  source    = "../../../terraform-k8s-modules/modules/kubernetes/secret"
  name      = "image-pull-secret"
  namespace = var.namespace

  type = "kubernetes.io/dockerconfigjson"
  from-map = {
    ".dockerconfigjson" = base64encode(file("${path.module}/config.json"))
  }
}
