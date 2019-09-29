resource "k8s_core_v1_config_map" "istio-grafana-custom-resources" {
  data = {
    "custom-resources.yaml" = <<-EOF
      apiVersion: authentication.istio.io/v1alpha1
      kind: Policy
      metadata:
        name: grafana-ports-mtls-disabled
        namespace: ${var.namespace}
        labels:
          app: grafana
          chart: grafana
          heritage: Tiller
          release: istio
      spec:
        targets:
        - name: grafana
          ports:
          - number: 3000
      EOF
    "run.sh" = <<-EOF
      #!/bin/sh
      
      set -x
      
      if [ "$#" -ne "1" ]; then
          echo "first argument should be path to custom resource yaml"
          exit 1
      fi
      
      pathToResourceYAML=$${1}
      
      kubectl get validatingwebhookconfiguration istio-galley 2>/dev/null
      if [ "$?" -eq 0 ]; then
          echo "istio-galley validatingwebhookconfiguration found - waiting for istio-galley deployment to be ready"
          while true; do
              kubectl -n ${var.namespace} get deployment istio-galley 2>/dev/null
              if [ "$?" -eq 0 ]; then
                  break
              fi
              sleep 1
          done
          kubectl -n ${var.namespace} rollout status deployment istio-galley
          if [ "$?" -ne 0 ]; then
              echo "istio-galley deployment rollout status check failed"
              exit 1
          fi
          echo "istio-galley deployment ready for configuration validation"
      fi
      sleep 5
      kubectl apply -f $${pathToResourceYAML}
      EOF
  }
  metadata {
    labels = {
      "app"      = "grafana"
      "chart"    = "grafana"
      "heritage" = "Tiller"
      "istio"    = "grafana"
      "release"  = "istio"
    }
    name      = "istio-grafana-custom-resources"
    namespace = "${var.namespace}"
  }
}