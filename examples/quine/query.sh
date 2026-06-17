ENDPOINT=http://quine.quine-example:8080
read -r -d ''  CYPHER <<EOF
match (n) return n
EOF

curl -s --request POST \
  --url "${ENDPOINT}/api/v1/query/cypher" \
  --header 'Accept: application/json' \
  --header 'Content-Type: text/plain' \
  --data "${CYPHER}" \
  | jq .