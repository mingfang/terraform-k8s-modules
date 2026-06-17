helm template my-vcluster vcluster --repo https://charts.loft.sh -n vcluster \
--set isolation.enabled=true \
> vcluster.yaml