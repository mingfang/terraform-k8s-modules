resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

// grant admin to this namespace
resource "k8s_rbac_authorization_k8s_io_v1_role_binding" "admin" {
  metadata {
    name      = "admin"
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }

  subjects {
    kind = "ServiceAccount"
    name = "default"
  }
  role_ref {
    kind      = "ClusterRole"
    name      = "admin"
    api_group = "rbac.authorization.k8s.io"
  }
}

// volume to store project files
resource "k8s_core_v1_persistent_volume_claim" "data" {
  metadata {
    name      = "data"
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }

  spec {
    access_modes = ["ReadWriteMany"]
    resources { requests = { "storage" = "1Gi" } }
    storage_class_name = "cephfs"
  }
}

// IntelliJ with Docker In Docker(DinD) support
module "intellij" {
  source    = "../../modules/intellij"
  name      = var.name
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  env = [
    {
      name  = "DOCKER_HOST"
      value = "tcp://localhost:2375"
    }
  ]

  // add additional containers for your project such as db, messaging, etc
  additional_containers = [
    {
      name  = "dind"
      image = "docker:19-dind"
      args  = ["--insecure-registry=0.0.0.0/0"]
      env = [
        {
          name = "POD_NAME"
          value_from = {
            field_ref = {
              field_path = "metadata.name"
            }
          }
        },
        {
          name  = "DOCKER_TLS_CERTDIR"
          value = ""
        }
      ]
      security_context = {
        privileged = true
      }

      volume_mounts = [
        {
          name          = "data"
          mount_path    = "/var/lib/docker"
          sub_path_expr = ".docker/$(POD_NAME)/var/lib/docker"
        },
      ]
    }
  ]

  pvc = k8s_core_v1_persistent_volume_claim.data.metadata[0].name
}

// load IntelliJ using https://<namespace>.<your domain>?port=443
resource "k8s_networking_k8s_io_v1beta1_ingress" "this" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"                    = "nginx"
      "nginx.ingress.kubernetes.io/server-alias"       = "${var.namespace}.*"
      "nginx.ingress.kubernetes.io/force-ssl-redirect" = "true"
    }
    name      = module.intellij.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${module.intellij.name}-${var.namespace}"
      http {
        paths {
          path = "/"
          backend {
            service_name = module.intellij.name
            service_port = module.intellij.ports[0].port
          }
        }
        paths {
          path = "/proxy"
          backend {
            service_name = module.nginx.name
            service_port = module.nginx.ports[0].port
          }
        }
      }
    }
  }
}

module "nginx" {
  source    = "../../modules/nginx"
  name      = "nginx"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  default-conf = <<-EOF
    server {
      listen      80;

      location ~ /proxy/(.*)/(.*) {
        resolver 172.27.0.2 ipv6=off;
        proxy_pass http://${module.intellij.name}-0.${module.intellij.name}.${k8s_core_v1_namespace.this.metadata[0].name}.svc.cluster.local:$1/$2;
      }
    }
    EOF
}

/*
// Pycharm Community

module "pycharm-community" {
  source    = "../../modules/intellij"
  name      = "pycharm-community"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  image     = "registry.rebelsoft.com/projector-pycharm-community"

  env = [
    {
      name  = "DOCKER_HOST"
      value = "tcp://localhost:2375"
    }
  ]

  // add additional containers for your project such as db, messaging, etc
  additional_containers = [
    {
      name  = "dind"
      image = "docker:19-dind"
      args  = ["--insecure-registry=0.0.0.0/0"]
      env = [
        {
          name = "POD_NAME"
          value_from = {
            field_ref = {
              field_path = "metadata.name"
            }
          }
        },
        {
          name  = "DOCKER_TLS_CERTDIR"
          value = ""
        }
      ]
      security_context = {
        privileged = true
      }

      volume_mounts = [
        {
          name          = "data"
          mount_path    = "/var/lib/docker"
          sub_path_expr = "docker/$(POD_NAME)/var/lib/docker"
        },
      ]
    }
  ]

  pvc = k8s_core_v1_persistent_volume_claim.data.metadata[0].name
}

// load IntelliJ using https://<namespace>.<your domain>?port=443
resource "k8s_networking_k8s_io_v1beta1_ingress" "pycharm-community" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"                    = "nginx"
      "nginx.ingress.kubernetes.io/server-alias"       = "pycharm-community-example.*"
      "nginx.ingress.kubernetes.io/force-ssl-redirect" = "true"
    }
    name      = module.pycharm-community.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${module.pycharm-community.name}-${var.namespace}"
      http {
        paths {
          backend {
            service_name = module.pycharm-community.name
            service_port = module.pycharm-community.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}

// Pycharm Professional

module "pycharm" {
  source    = "../../modules/intellij"
  name      = "pycharm"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  image     = "registry.rebelsoft.com/projector-pycharm-professional"

  env = [
    {
      name  = "DOCKER_HOST"
      value = "tcp://localhost:2375"
    }
  ]

  // add additional containers for your project such as db, messaging, etc
  additional_containers = [
    {
      name  = "dind"
      image = "docker:19-dind"
      args  = ["--insecure-registry=0.0.0.0/0"]
      env = [
        {
          name = "POD_NAME"
          value_from = {
            field_ref = {
              field_path = "metadata.name"
            }
          }
        },
        {
          name  = "DOCKER_TLS_CERTDIR"
          value = ""
        }
      ]
      security_context = {
        privileged = true
      }

      volume_mounts = [
        {
          name          = "data"
          mount_path    = "/var/lib/docker"
          sub_path_expr = "docker/$(POD_NAME)/var/lib/docker"
        },
      ]
    }
  ]

  pvc = k8s_core_v1_persistent_volume_claim.data.metadata[0].name
}

// load IntelliJ using https://<namespace>.<your domain>?port=443
resource "k8s_networking_k8s_io_v1beta1_ingress" "pycharm" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"                    = "nginx"
      "nginx.ingress.kubernetes.io/server-alias"       = "pycharm-example.*"
      "nginx.ingress.kubernetes.io/force-ssl-redirect" = "true"
    }
    name      = module.pycharm.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${module.pycharm.name}-${var.namespace}"
      http {
        paths {
          backend {
            service_name = module.pycharm.name
            service_port = module.pycharm.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}

// Datagrip

module "datagrip" {
  source    = "../../modules/intellij"
  name      = "datagrip"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  image     = "registry.rebelsoft.com/projector-datagrip"

  env = [
    {
      name  = "DOCKER_HOST"
      value = "tcp://localhost:2375"
    }
  ]

  // add additional containers for your project such as db, messaging, etc
  additional_containers = [
    {
      name  = "dind"
      image = "docker:19-dind"
      args  = ["--insecure-registry=0.0.0.0/0"]
      env = [
        {
          name = "POD_NAME"
          value_from = {
            field_ref = {
              field_path = "metadata.name"
            }
          }
        },
        {
          name  = "DOCKER_TLS_CERTDIR"
          value = ""
        }
      ]
      security_context = {
        privileged = true
      }

      volume_mounts = [
        {
          name          = "data"
          mount_path    = "/var/lib/docker"
          sub_path_expr = "docker/$(POD_NAME)/var/lib/docker"
        },
      ]
    }
  ]

  pvc = k8s_core_v1_persistent_volume_claim.data.metadata[0].name
}

// load IntelliJ using https://<namespace>.<your domain>?port=443
resource "k8s_networking_k8s_io_v1beta1_ingress" "datagrip" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"                    = "nginx"
      "nginx.ingress.kubernetes.io/server-alias"       = "datagrip-example.*"
      "nginx.ingress.kubernetes.io/force-ssl-redirect" = "true"
    }
    name      = module.datagrip.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${module.datagrip.name}-${var.namespace}"
      http {
        paths {
          backend {
            service_name = module.datagrip.name
            service_port = module.datagrip.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}

// Rider

module "rider" {
  source    = "../../modules/intellij"
  name      = "rider"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  image     = "registry.rebelsoft.com/projector-rider"

  env = [
    {
      name  = "DOCKER_HOST"
      value = "tcp://localhost:2375"
    }
  ]

  // add additional containers for your project such as db, messaging, etc
  additional_containers = [
    {
      name  = "dind"
      image = "docker:19-dind"
      args  = ["--insecure-registry=0.0.0.0/0"]
      env = [
        {
          name = "POD_NAME"
          value_from = {
            field_ref = {
              field_path = "metadata.name"
            }
          }
        },
        {
          name  = "DOCKER_TLS_CERTDIR"
          value = ""
        }
      ]
      security_context = {
        privileged = true
      }

      volume_mounts = [
        {
          name          = "data"
          mount_path    = "/var/lib/docker"
          sub_path_expr = "docker/$(POD_NAME)/var/lib/docker"
        },
      ]
    }
  ]

  pvc = k8s_core_v1_persistent_volume_claim.data.metadata[0].name
}

// load IntelliJ using https://<namespace>.<your domain>?port=443
resource "k8s_networking_k8s_io_v1beta1_ingress" "rider" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"                    = "nginx"
      "nginx.ingress.kubernetes.io/server-alias"       = "rider-example.*"
      "nginx.ingress.kubernetes.io/force-ssl-redirect" = "true"
    }
    name      = module.rider.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${module.rider.name}-${var.namespace}"
      http {
        paths {
          backend {
            service_name = module.rider.name
            service_port = module.rider.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}

*/
