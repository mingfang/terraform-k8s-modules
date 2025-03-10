/*
Note: Must apply the CRD module before attempting to apply this module
*/

resource "k8s_core_v1_namespace" "istio-system" {
  metadata {
    labels = {
      "istio-injection" = "disabled"
    }
    name = "istio-system"
  }
}

/*
This modules includes all the core Istio modules.
*/
module "istio" {
  source    = "../../solutions/istio"
  namespace = k8s_core_v1_namespace.istio-system.metadata[0].name
}

/*
This module includes the additional Istio modules with UI and monitoring
*/
module "istio-telemetry" {
  source    = "../../solutions/istio-telemetry"
  namespace = k8s_core_v1_namespace.istio-system.metadata[0].name
}


