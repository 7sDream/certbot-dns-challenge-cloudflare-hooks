#!/bin/bash

DIR="$(dirname "$0")"
source "$DIR/config.sh"

echo "DOMAIN: ${CHALLENGE_DOMAIN}"
echo "ZONE: ${CLOUDFLARE_ZONE}"

records=($(curl -X GET "https://api.cloudflare.com/client/v4/zones/${CLOUDFLARE_ZONE}/dns_records?type=TXT&name=${CHALLENGE_DOMAIN}&page=1&per_page=100" \
     -H "X-Auth-Email: ${CLOUDFLARE_EMAIL}" \
     -H "X-Auth-Key: ${CLOUDFLARE_KEY}" \
     -H "Content-Type: application/json" -s | jq -r ".result[].id"))

echo "${records}"

for record in "${records[@]}"; do
    echo "clean: $record"
    curl -X DELETE "https://api.cloudflare.com/client/v4/zones/${CLOUDFLARE_ZONE}/dns_records/${record}" \
    	-H "X-Auth-Email: ${CLOUDFLARE_EMAIL}" \
    	-H "X-Auth-Key: ${CLOUDFLARE_KEY}" \
    	-H "Content-Type: application/json" -s | jq -r "[.success, .errors[].message] | @csv"
done
