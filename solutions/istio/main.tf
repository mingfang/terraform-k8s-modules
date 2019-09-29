/*
config
*/

module "istio" {
  source    = "../../modules/istio/istio-1.1.0"
  namespace = var.namespace
}

/*
citadel
*/

module "security" {
  source    = "../../modules/istio/security"
  namespace = var.namespace
}

/*
galley
*/

module "galley" {
  source    = "../../modules/istio/galley"
  namespace = var.namespace
}

/*
pilot
*/

module "pilot" {
  source    = "../../modules/istio/pilot"
  namespace = var.namespace
}

/*
mixer
*/

module "mixer" {
  source    = "../../modules/istio/mixer"
  namespace = var.namespace
}

/*
gateways
*/

module "gateways" {
  source    = "../../modules/istio/gateways"
  namespace = var.namespace
  type      = "${var.ingress_type}"
}

/*
sidecar injector
*/

module "sidecar-injector" {
  source    = "../../modules/istio/sidecarInjectorWebhook"
  namespace = var.namespace
}

