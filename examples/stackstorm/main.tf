resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

# required system services

module "redis" {
  source    = "../../modules/redis"
  name      = "redis"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  replicas = 1
}

module "mongodb" {
  source    = "../../modules/mongodb"
  name      = "mongodb"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  replicas      = 1
  storage       = "1Gi"
  storage_class = "cephfs"

  #  MONGO_INITDB_DATABASE      = "st2"
  #  MONGO_INITDB_ROOT_USERNAME = "mongodb"
  #  MONGO_INITDB_ROOT_PASSWORD = "mongodb"
}

module "rabbitmq" {
  source    = "../../modules/rabbitmq"
  name      = "rabbitmq"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  replicas      = 1
  storage       = "1Gi"
  storage_class = "cephfs"

  RABBITMQ_ERLANG_COOKIE = "RABBITMQ_ERLANG_COOKIE"
}

# global configuration

module "config" {
  source    = "../../modules/kubernetes/config-map"
  name      = "config"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  from-map = {
    "st2.docker.conf" = <<-EOF
    [rbac]
    enable = True
    backend = default

    [auth]
    api_url = http://st2api:9101/

    [messaging]
    url = amqp://guest:guest@${module.rabbitmq.name}:5672

    [keyvalue]
    encryption_key_path = /etc/st2/keys/datastore_key.json

    [database]
    host = ${module.mongodb.name}
    connection_retry_max_delay_m = 1
    connection_retry_backoff_mul = 1
    connection_timeout = 3000

    [coordination]
    url = redis://${module.redis.name}:6379
    EOF

    "htpasswd" = <<-EOF
    st2admin:$apr1$GjA7KmRf$nmbcSB1XoYRPfQrL9ZBD5.
    EOF
  }
}

module "config-rbac-assignments" {
  source    = "../../modules/kubernetes/config-map"
  name      = "config-rbac-assignments"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  from-map = {
    "st2admin.yaml" = <<-EOF
    ---
    username: st2admin
    roles:
      - system_admin
    EOF
  }
}

# shared persistent volumes

resource "k8s_core_v1_persistent_volume_claim" "stackstorm-packs-configs" {
  metadata {
    name      = "stackstorm-packs-configs"
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }

  spec {
    access_modes = ["ReadWriteOnce"]
    resources { requests = { "storage" = "1Gi" } }
    storage_class_name = "cephfs"
  }
}
resource "k8s_core_v1_persistent_volume_claim" "stackstorm-packs" {
  metadata {
    name      = "stackstorm-packs"
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }

  spec {
    access_modes = ["ReadWriteOnce"]
    resources { requests = { "storage" = "1Gi" } }
    storage_class_name = "cephfs"
  }
}
resource "k8s_core_v1_persistent_volume_claim" "stackstorm-virtualenvs" {
  metadata {
    name      = "stackstorm-virtualenvs"
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }

  spec {
    access_modes = ["ReadWriteOnce"]
    resources { requests = { "storage" = "1Gi" } }
    storage_class_name = "cephfs"
  }
}
resource "k8s_core_v1_persistent_volume_claim" "stackstorm-ssh" {
  metadata {
    name      = "stackstorm-ssh"
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }

  spec {
    access_modes = ["ReadWriteOnce"]
    resources { requests = { "storage" = "1Gi" } }
    storage_class_name = "cephfs"
  }
}
resource "k8s_core_v1_persistent_volume_claim" "stackstorm-keys" {
  metadata {
    name      = "stackstorm-keys"
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }

  spec {
    access_modes = ["ReadWriteOnce"]
    resources { requests = { "storage" = "1Gi" } }
    storage_class_name = "cephfs"
  }
}

# StackStorm services

module "st2api" {
  source    = "../../modules/stackstorm/st2api"
  name      = "st2api"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  config_map                        = module.config.name
  config_map_rbac_assignments       = module.config-rbac-assignments.name
  stackstorm_keys_pvc_name          = k8s_core_v1_persistent_volume_claim.stackstorm-keys.metadata[0].name
  stackstorm_packs_configs_pvc_name = k8s_core_v1_persistent_volume_claim.stackstorm-packs-configs.metadata[0].name
  stackstorm_packs_pvc_name         = k8s_core_v1_persistent_volume_claim.stackstorm-packs.metadata[0].name

  ST2_AUTH_URL   = "http://st2auth:9100/"
  ST2_API_URL    = "http://st2api:9101/"
  ST2_STREAM_URL = "http://st2stream:9102/"
}

module "st2stream" {
  source    = "../../modules/stackstorm/st2stream"
  name      = "st2stream"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  config_map = module.config.name
}

module "st2scheduler" {
  source    = "../../modules/stackstorm/st2scheduler"
  name      = "st2scheduler"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  config_map = module.config.name
}

module "st2workflowengine" {
  source    = "../../modules/stackstorm/st2workflowengine"
  name      = "st2workflowengine"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  config_map               = module.config.name
  stackstorm_keys_pvc_name = k8s_core_v1_persistent_volume_claim.stackstorm-keys.metadata[0].name
}

module "st2auth" {
  source    = "../../modules/stackstorm/st2auth"
  name      = "st2auth"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  config_map = module.config.name
}

// grant admin to this namespace for kubectl to work
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

module "st2actionrunner" {
  source    = "../../modules/stackstorm/st2actionrunner"
  name      = "st2actionrunner"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  config_map                        = module.config.name
  stackstorm_keys_pvc_name          = k8s_core_v1_persistent_volume_claim.stackstorm-keys.metadata[0].name
  stackstorm_packs_configs_pvc_name = k8s_core_v1_persistent_volume_claim.stackstorm-packs-configs.metadata[0].name
  stackstorm_packs_pvc_name         = k8s_core_v1_persistent_volume_claim.stackstorm-packs.metadata[0].name
  stackstorm_virtualenvs_pvc_name   = k8s_core_v1_persistent_volume_claim.stackstorm-virtualenvs.metadata[0].name
  stackstorm_ssh_pvc_name           = k8s_core_v1_persistent_volume_claim.stackstorm-ssh.metadata[0].name

  # Custom st2actionrunner to include additional tools such as Docker, Kubectl, Terraform, etc
  image = "registry.rebelsoft.com/st2actionrunner:latest"

  # Docker-in-Docker setup to enable running plain Docker commands
  env = [
    {
      name  = "DOCKER_HOST"
      value = "tcp://localhost:2375"
    }
  ]
  additional_containers = [
    {
      name  = "dind"
      image = "docker:20.10.9-dind"
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
    }
  ]
}

module "st2garbagecollector" {
  source    = "../../modules/stackstorm/st2garbagecollector"
  name      = "st2garbagecollector"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  config_map = module.config.name
}

module "st2notifier" {
  source    = "../../modules/stackstorm/st2notifier"
  name      = "st2notifier"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  config_map = module.config.name
}

module "st2rulesengine" {
  source    = "../../modules/stackstorm/st2rulesengine"
  name      = "st2rulesengine"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  config_map = module.config.name
}

module "st2sensorcontainer" {
  source    = "../../modules/stackstorm/st2sensorcontainer"
  name      = "st2sensorcontainer"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  config_map                        = module.config.name
  stackstorm_packs_configs_pvc_name = k8s_core_v1_persistent_volume_claim.stackstorm-packs-configs.metadata[0].name
  stackstorm_packs_pvc_name         = k8s_core_v1_persistent_volume_claim.stackstorm-packs.metadata[0].name
  stackstorm_virtualenvs_pvc_name   = k8s_core_v1_persistent_volume_claim.stackstorm-virtualenvs.metadata[0].name
}

module "st2timersengine" {
  source    = "../../modules/stackstorm/st2timersengine"
  name      = "st2timersengine"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  config_map = module.config.name
}

module "st2chatops" {
  source    = "../../modules/stackstorm/st2chatops"
  name      = "st2chatops"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  ST2_AUTH_URL    = "http://st2auth:9100/"
  ST2_API_URL     = "http://st2api:9101/"
  ST2_STREAM_URL  = "http://st2stream:9102/"
  HUBOT_ADAPTER   = "slack"
  HUBOT_LOG_LEVEL = "debug"
  env = [
    {
      name  = "HUBOT_SLACK_TOKEN"
      value = var.HUBOT_SLACK_TOKEN
    },
    {
      name  = "ST2_AUTH_USERNAME"
      value = "st2admin"
    },
    {
      name  = "ST2_AUTH_PASSWORD"
      value = "Ch@ngeMe"
    }
  ]
}

module "st2web" {
  source    = "../../modules/stackstorm/st2web"
  name      = "st2web"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  ST2_AUTH_URL   = "http://st2auth:9100/"
  ST2_API_URL    = "http://st2api:9101/"
  ST2_STREAM_URL = "http://st2stream:9102/"
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "st2web" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${var.namespace}.*"
    }
    name      = module.st2web.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = var.namespace
      http {
        paths {
          backend {
            service_name = module.st2web.name
            service_port = module.st2web.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}
