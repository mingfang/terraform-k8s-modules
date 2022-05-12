resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "vault-k8s" {
  source                  = "../../modules/vault-k8s"
  name                    = var.name
  namespace               = k8s_core_v1_namespace.this.metadata[0].name
  AGENT_INJECT_VAULT_ADDR = "http://z1:8200"
  AGENT_INJECT_LOG_LEVEL  = "debug"
}

module "nginx" {
  source    = "../../modules/nginx"
  name      = "nginx"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  annotations = {
    //Vault role
    "vault.hashicorp.com/agent-inject" = "true"
    "vault.hashicorp.com/role"         = "vault-agent"
    //init container, no sidecar
    "vault.hashicorp.com/agent-init-first"        = "true"
    "vault.hashicorp.com/agent-pre-populate"      = "true"
    "vault.hashicorp.com/agent-pre-populate-only" = "true"
    //secret stored on Vault
    "vault.hashicorp.com/agent-inject-secret-helloworld" = "secret/data/vault-agent/helloworld"
    "vault.hashicorp.com/agent-inject-file-helloworld"   = "html/index.html"
    //custom go template rendering
    "vault.hashicorp.com/agent-inject-template-helloworld" = <<-EOF
      <html>
      <body>
      {{- with secret "secret/data/vault-agent/helloworld" }}
        {{- range $k, $v := .Data }}
            {{ $k }}: {{ $v }}
        {{- end }}
      {{- end }}
      </body>
      </html>
      EOF
  }

  default-conf = <<-EOF
    server {
      server_name _;
      root /vault/secrets/html;
    }
    EOF
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "nginx" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${var.namespace}.*"
    }
    name      = module.nginx.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${module.nginx.name}-${var.namespace}"
      http {
        paths {
          backend {
            service_name = module.nginx.name
            service_port = module.nginx.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}
