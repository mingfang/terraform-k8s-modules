resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

resource "random_password" "keyfile" {
  length  = 256
  special = false
}

module "secret" {
  source    = "../../modules/kubernetes/secret"
  name      = var.name
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  from-map = {
    "keyfile" = base64encode(random_password.keyfile.result)
  }
}

/* MongoDB Replica Set */

module "mongodb" {
  source    = "../../modules/mongodb"
  name      = "mongodb"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 2

  storage_class = "cephfs"
  storage       = "1Gi"

  MONGO_INITDB_DATABASE      = "mydb"
  MONGO_INITDB_ROOT_USERNAME = "mongo"
  MONGO_INITDB_ROOT_PASSWORD = "mongo"
  keyfile_secret             = module.secret.name
}

module "mongo-express" {
  source    = "../../modules/mongo-express"
  name      = "mongo-express"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 1

  ME_CONFIG_MONGODB_URL = "mongodb://mongo:mongo@${module.mongodb.seed_list}"
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "mongo-express" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "mongo-express-${var.namespace}.*"
    }
    name      = module.mongo-express.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "mongo-express-${var.namespace}"
      http {
        paths {
          backend {
            service_name = module.mongo-express.name
            service_port = module.mongo-express.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}

module "redis" {
  source    = "../../modules/redis"
  name      = "redis"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
}

module "wildduck" {
  source    = "../../modules/wildduck"
  name      = var.name
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  env = [
    {
      name="FQDN"
      value="example.com"
    },
    {
      name="MAIL_DOMAIN"
      value="mail.example.com"
    },
    {

      name="CMD_ARGS"
      value=<<-EOF
      --dbs.mongo=mongodb://mongo:mongo@${module.mongodb.seed_list}
      --dbs.redis=redis://${module.redis.name}:${module.redis.ports[0].port}
      --smtp.setup.hostname=$(FQDN)
      --log.gelf.hostname=$(FQDN)
      --imap.setup.hostname=$(FQDN)
      --emailDomain=$(MAIL_DOMAIN)
      --api.host=0.0.0.0
      EOF
    },
  ]
}

module "config" {
  source = "../../modules/kubernetes/config-map"
  name      = "webmail-config"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  from-map = {
    "config.toml" = <<-EOF
      name="Wild Duck Mail"

      title="wildduck-www"

      [service]
          # email domain for new users
          domain="example.com"
          # default quotas for new users
          quota=1024
          recipients=2000
          forwards=2000
          identities=10
          allowIdentityEdit=true
          allowJoin=true
          enableSpecial=false # if true the allow creating addresses with special usernames
          # allowed domains for new addresses
          domains=["example.com"]

          generalNotification="" # static notification to show on top of the page

          [service.sso.http]
              enabled = false
              header = "X-UserName" # value from this header is treated as logged in username
              authRedirect = "http:/127.0.0.1:3000/login" # URL to redirect non-authenticated users
              logoutRedirect = "http:/127.0.0.1:3000/logout"  # URL to redirect when user clicks on "log out"

      [api]
          url="http://${module.wildduck.name}:${module.wildduck.ports[0].port}"
          accessToken=""

      [dbs]
          # mongodb connection string for the main database
          mongo="mongodb://mongo:mongo@${module.mongodb.seed_list}"

          # redis connection string for Express sessions
          redis="redis://${module.redis.name}:${module.redis.ports[0].port}/5"

      [www]
          host=false
          port=3000
          proxy=true
          postsize="5MB"
          log="dev"
          secret="a cat"
          secure=false
          listSize=20

      [recaptcha]
          enabled=false
          siteKey=""
          secretKey=""

      [totp]
          # Issuer name for TOTP, defaults to config.name
          issuer=false
          # once setup do not change as it would invalidate all existing 2fa sessions
          secret="a secret cat"

      [u2f]
          # set to false if not using HTTPS
          enabled=true
          # must be https url or use default
          #appId="https://127.0.0.1:8080"

      [log]
          level="silly"
          mail=true

      [setup]
          # these values are shown in the configuration help page
          [setup.imap]
              hostname="0.0.0.0"
              secure=true
              port=9993
          [setup.pop3]
              hostname="0.0.0.0"
              secure=true
              port=9995
          [setup.smtp]
              hostname="0.0.0.0"
              secure=false
              port=2587
    EOF
  }
}
module "wildduck-webmail" {
  source    = "../../modules/wildduck-webmail"
  name      = "webmail"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  configmap = module.config.config_map
  args = ["--config=/etc/webmail/config.toml"]
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "api" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"                 = "nginx"
      "nginx.ingress.kubernetes.io/server-alias"    = "api-${var.namespace}.*"
    }
    name      = module.wildduck.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${module.wildduck.name}.${var.namespace}"
      http {
        paths {
          backend {
            service_name = module.wildduck.name
            service_port = module.wildduck.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}
resource "k8s_networking_k8s_io_v1beta1_ingress" "webmail" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"                 = "nginx"
      "nginx.ingress.kubernetes.io/server-alias"    = "webmail-${var.namespace}.*"
    }
    name      = module.wildduck-webmail.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${module.wildduck-webmail.name}.${var.namespace}"
      http {
        paths {
          backend {
            service_name = module.wildduck-webmail.name
            service_port = module.wildduck-webmail.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}


