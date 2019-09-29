/*
The Istio Custom Resource Definitions(CRD) must be applied first, otherwise the other Istio modules will fail.
*/
module "istio-crd" {
  source = "./modules/istio/crd"
}


/*
The Istio namespace must create first.
Notice the Isito modules' namespace references this namespace resource.
This creats a natural depenency causing the namespace to be create first and destroyed last.
*/
/*
resource "k8s_core_v1_namespace" "istio-system" {
  metadata {
    labels = {
      "istio-injection" = "disabled"
    }
    name = "istio-system"
  }
}
*/

/*
This modules includes all the core Istio modules.
*/
/*
module "istio" {
  source = "./solutions/istio"
  namespace = k8s_core_v1_namespace.istio-system.metadata[0].name
}
*/

/*
This module includes the additional Istio modules with UI and monitoring
*/
/*
module "istio-telemetry" {
  source = "./solutions/istio-telemetry"
  namespace = k8s_core_v1_namespace.istio-system.metadata[0].name
}
*/


