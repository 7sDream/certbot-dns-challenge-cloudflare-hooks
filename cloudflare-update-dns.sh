#!/bin/bash

DIR="$(dirname "$0")"
source "$DIR/config.sh"

DNS_SERVER=8.8.8.8

echo "CHALLENGE_DOMAIN: ${CHALLENGE_DOMAIN}"
echo "CHALLENGE_VALUE: ${CERTBOT_VALIDATION}"
echo "DNS_SERVER: ${DNS_SERVER}"
echo "ZONE: ${CLOUDFLARE_ZONE}"

ADD_RECORD_RESULT=$(curl -X POST "https://api.cloudflare.com/client/v4/zones/${CLOUDFLARE_ZONE}/dns_records" \
     -H "X-Auth-Email: ${CLOUDFLARE_EMAIL}" \
     -H "X-Auth-Key: ${CLOUDFLARE_KEY}" \
     -H "Content-Type: application/json" \
     --data "{\"type\":\"TXT\",\"name\":\"_acme-challenge\",\"content\":\"${CERTBOT_VALIDATION}\", \"ttl\": 120}" -s | jq -r "[.success, .errors[].message] | @csv")

echo "Add record result: ${ADD_RECORD_RESULT}"

if [[ ! $(echo "${ADD_RECORD_RESULT}" | grep "true") ]]; then
    echo "Add record failed, exit"
    exit 1
fi

while true; do
    records=$(dig -t TXT ${CHALLENGE_DOMAIN} @${DNS_SERVER} +noall +answer +short | grep "${CERTBOT_VALIDATION}")
    if [[ ${records} ]]; then
        break
    fi
    echo "DNS records have not been propagate, sleep 10s..."
    sleep 10
done

echo "DNS record have been propagated, finish"

