shopt -s expand_aliases

host="https://keycloak.rebelsoft.com"
realm="rebelsoft"
auth=$(echo -n quickstart:8Jmcl8hlmfhXNm3EBdYDQvXG0Ph5Ya3N|base64)

# host="https://login.dev.kkr.com"
# realm="kkr"
# auth=$(echo -n saviynt:5aEe4qoCNVQ8NCUSU7vLqYO1o5Ou2g3r|base64)

token=$(curl -XPOST -sk -H "Authorization: Basic $auth" -H 'Content-Type: application/x-www-form-urlencoded' -d 'grant_type=client_credentials' $host/auth/realms/$realm/protocol/openid-connect/token|jq -r .access_token)


get(){
    url=$host/auth/admin/realms/$realm$1
    curl -sk -H "Authorization: Bearer $token" $url -v
}
post(){
    curl -X POST -d $2 -sk -H "Authorization: Bearer $token" -H "Content-Type: application/json" $host/auth/admin/realms/$realm$1 -v
}

# get /users | jq
# post /user '{"email": "test@test.com"}' | jq

get /groups | jq