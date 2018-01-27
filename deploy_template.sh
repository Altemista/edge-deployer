#!/bin/bash
if [ x = x$1 -o x = x$2 -o x = x$3 -o x = x$4 -o x = x$5 ]; then
    echo "Usage: ./deploy_template.sh "
    echo "           <server>"
    echo "           <tenant>"
    echo "           <user>"
    echo "           <password>"
    echo "           <template>"
    echo "           <hostname>"
    exit
fi

SERVER=$1
TENANT=$2
USER=$3
PASSWORD=$4
TEMPLATE=$5
HOSTNAME=$6

export TOKEN=`curl -s  -H "Content-type: application/json"  -X POST https://$SERVER:443/keystone/v2.0/tokens -d "{ \"auth\": { \"tenantName\": \"$TENANT\", \"passwordCredentials\": { \"username\": \"$USER\", \"password\": \"$PASSWORD\"}}}" | jq '.access.token.id' | tr -d '"'`
echo $TOKEN

sed -e "s/__HOSTNAME__/$HOSTNAME/g" < $TEMPLATE.tpl > $TEMPLATE.json
curl -X POST -H "X-Auth-Token: $TOKEN" https://$SERVER/gohan/v1.0/service_templates -d @$TEMPLATE.json
rm $TEMPLATE.json
