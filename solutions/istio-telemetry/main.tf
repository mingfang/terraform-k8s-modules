
/*
prometheus
*/

module "prometheus" {
  source    = "../../modules/istio/prometheus"
  namespace = var.namespace
}

/*
grafana
*/

module "grafana" {
  source    = "../../modules/istio/grafana"
  namespace = var.namespace
}

/*
tracing
*/

module "tracing" {
  source    = "../../modules/istio/tracing"
  namespace = var.namespace
}

/*
kiali
*/

module "kiali" {
  source    = "../../modules/istio/kiali"
  namespace = var.namespace
}

/*
Ingress Gateways and VirtualServices
*/

module "ingress" {
  source = "./ingress"
}