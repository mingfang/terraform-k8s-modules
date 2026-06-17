for dir in ${1:-examples}; do
  find -name main.tf -printf '%P\n' | grep -v .terraform | xargs -I{} dirname {} | xargs -I{} sh -cx \
  'cp versions.tf $1; git add $1/versions.tf' -- {}
done
