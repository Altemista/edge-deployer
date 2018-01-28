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
echo "TOKEN=$TOKEN"

export COMPOSE=`sed -e ':a' -e 'N' -e '$!ba' -e 's/\n/\\\\\\\\n/g' -e 's/"/\\\\\\\\"/g' -e "s/__HOSTNAME__/$HOSTNAME/g" < $TEMPLATE.compose.yaml`
echo "COMPOSE=$COMPOSE"

sed -e "s+__COMPOSE__+$COMPOSE+g" < $TEMPLATE.tpl > $TEMPLATE.json
cat $TEMPLATE.json
curl -X POST -H "X-Auth-Token: $TOKEN" https://$SERVER/gohan/v1.0/service_templates -d @$TEMPLATE.json
rm $TEMPLATE.json
