NAMESPACE=$1
INGRESS=$2

JSON=$(kubectl get ingress -o json -n $NAMESPACE  $INGRESS)
echo $JSON | jq .
NAME=$(echo $JSON|jq -r '.metadata.name')
cat <<EOF
resource "k8s_networking_k8s_io_v1_ingress" "$NAME" {
    metadata {
        annotations = {
        "kubernetes.io/ingress.class"              = "nginx"
        "nginx.ingress.kubernetes.io/server-alias" = "\${var.namespace}.*"
        "nginx.ingress.kubernetes.io/ssl-redirect" = "true"
        }
        name      = var.namespace
        namespace = k8s_core_v1_namespace.this.metadata[0].name
    }
    spec {
        rules {
            host = var.namespace
            http {
                paths {
                    backend {
                        service {
                            name = module.$NAME.name
                            port {
                                number = module.$NAME.ports[0].port
                            }
                        }
                    }
                    path = "/"
                    path_type = "ImplementationSpecific"
                }
            }
        }
    }
}    

EOF