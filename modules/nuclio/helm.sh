helm repo add nuclio https://nuclio.github.io/nuclio/charts
helm template \
  --set registry.pushPullUrl=localhost:5000 \
  --set registry.defaultOnbuildRegistryURL=localhost:5000 \
  --set dashboard.containerBuilderKind=kaniko \
  --set autoscaler.enabled=true \
  --set dlx.enabled=true \
  --set ingress.enabled=true \
  nuclio/nuclio > nuclio.yaml