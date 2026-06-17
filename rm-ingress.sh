terraform state list|grep v1beta1_ingress|xargs -I{} terraform state rm {}
