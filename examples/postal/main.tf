resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

resource "tls_private_key" "signing_key" {
  algorithm = "RSA"
  rsa_bits  = 1024
}

module "secret" {
  source    = "../../modules/kubernetes/secret"
  name      = "config"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  from-map = {
    "signing.key" = base64encode(tls_private_key.signing_key.private_key_pem)
  }
}

module "config" {
  source    = "../../modules/kubernetes/config-map"
  name      = "config"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  from-map = {
    "postal.yml" = <<-EOF
      general:
        # This can be changed to allow messages to be sent from multiple IP addresses
        use_ip_pools: false

      web:
        # The host that the management interface will be available on
        host: postal
        # The protocol that requests to the management interface should happen on
        protocol: http

      web_server:
        # Specify configuration for the Postal web server
        bind_address: 0.0.0.0
        port: 5000

      smtp_server:
        # Specify configuration to the Postal SMTP server
        port: 25

      logging:
        # Specify options for the logging
        stdout: true

      main_db:
        # Specify the connection details for your MySQL database
        host: mysql
        username: root
        password: postal
        database: postal

      message_db:
        # Specify the connection details for your MySQL server that will be house the
        # message databases for mail servers.
        host: mysql
        username: root
        password: postal
        prefix: postal

      rabbitmq:
        # Specify connection details for your RabbitMQ server
        host: rabbitmq
        username: postal
        password: postal
        vhost: postal

      dns:
        # Specify the DNS records that you have configured. Refer to the documentation at
        # https://github.com/atech/postal/wiki/Domains-&-DNS-Configuration for further
        # information about these.
        mx_records:
          - mx.postal.example.com
        smtp_server_hostname: postal.example.com
        spf_include: spf.postal.example.com
        return_path: rp.postal.example.com
        route_domain: routes.postal.example.com
        track_domain: track.postal.example.com

      smtp:
        # Specify an SMTP server that can be used to send messages from the Postal management
        # system to users. You can configure this to use a Postal mail server once the
        # your installation has been set up.
        host: 127.0.0.1
        port: 2525
        username: # Complete when Postal is running and you can
        password: # generate the credentials within the interface.
        from_name: Postal
        from_address: postal@yourdomain.com

      rails:
        # This is generated automatically by the config initialization. It should be a random
        # string unique to your installation.
        secret_key: secretkey
    EOF
  }
}

module "mysql" {
  source    = "../../modules/mysql"
  name      = "mysql"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  image     = "mariadb"

  storage_class = "cephfs"
  storage       = "1Gi"
  replicas      = 1

  MYSQL_USER          = "postal"
  MYSQL_PASSWORD      = "postal"
  MYSQL_ROOT_PASSWORD = "postal"
  MYSQL_DATABASE      = "postal"
}

module "rabbitmq" {
  source    = "../../modules/rabbitmq"
  name      = "rabbitmq"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  storage_class = "cephfs"
  storage       = "1Gi"
  replicas      = 1

  RABBITMQ_ERLANG_COOKIE = "RABBITMQ_ERLANG_COOKIE"

  env = [
    {
      name  = "RABBITMQ_DEFAULT_USER"
      value = "postal"
    },
    {
      name  = "RABBITMQ_DEFAULT_PASS"
      value = "postal"
    },
    {
      name  = "RABBITMQ_DEFAULT_VHOST"
      value = "postal"
    },
  ]
}


module "web" {
  source    = "../../modules/postal/web"
  name      = "web"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  configmap = module.config.config_map
  secret    = module.secret.secret
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "this" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${var.namespace}.*",
    }
    name      = module.web.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = var.namespace
      http {
        paths {
          backend {
            service_name = module.web.name
            service_port = module.web.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}
