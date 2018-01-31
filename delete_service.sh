#!/bin/bash
if [ x = x$1 -o x = x$2 -o x = x$3 -o x = x$4 -o x = x$5 ]; then
    echo "Usage: ./deploy_template.sh "
    echo "           <server>"
    echo "           <tenant>"
    echo "           <user>"
    echo "           <password>"
    echo "           <service_id>"
    exit
fi

SERVER=$1
TENANT=$2
USER=$3
PASSWORD=$4
SERVICE_ID=$5

export TOKEN=`curl -s  -H "Content-type: application/json"  -X POST https://$SERVER:443/keystone/v2.0/tokens -d "{ \"auth\": { \"tenantName\": \"$TENANT\", \"passwordCredentials\": { \"username\": \"$USER\", \"password\": \"$PASSWORD\"}}}" | jq '.access.token.id' | tr -d '"'`

curl -X DELETE -H "X-Auth-Token: $TOKEN" https://$SERVER/gohan/v1.0/services/$SERVICE_ID
