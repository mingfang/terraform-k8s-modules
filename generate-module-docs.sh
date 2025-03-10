for dir in ${1:-archetypes modules examples}; do
  pushd "$dir"
  terraform fmt .
  find -name main.tf -printf '%P\n' | grep -v .terraform | xargs -I{} dirname {} | xargs -I{} sh -cx \
  '~/go/bin/terraform-config-inspect $1 | sed -E '"'"'s|from `(github\.com/mingfang/terraform-k8s-modules)/(.+)`|from [\1/\2](https://\1/tree/master/\2)|g'"'"' | sed -E '"'"'s|from `(\.\..+)`|from [\1](\1)|g'"'"'| sed -E '"'"'s|\(`(.+)`\):|([\1](https://registry.terraform.io/providers/\1/latest))|g'"'"' > $1/README.md; git add $1/README.md;' -- {}
  popd
done


#sh -cx '~/go/bin/terraform-config-inspect . | sed -E '"'"'s|from `(github\.com/mingfang/terraform-k8s-modules)/(.+)`|from [https://\1/\2](\1/tree/master/\2)|g'"'"''