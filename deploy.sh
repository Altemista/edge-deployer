#!/bin/bash

# See https://docs.openshift.org/latest/creating_images/custom.html#custom-builder-image
# for the list of environment variables set by OpenShift before the custom
# builder image is run.
#
# Although set as part of the API, the environment variables
# SOURCE_REPOSITORY/SOURCE_URI, SOURCE_CONTEXT_DIR and SOURCE_REF can also be
# derived from the BUILD environment variable using a tool such as `jq`
# (https://stedolan.github.io/jq/).  (Note: you would need to include the `jq`
# binary in your custom builder image).  If necessary, this technique can be
# used for extracting other values from the BUILD json from a shell script.
#

if [ x = x$1 -o x = x$2 -o x = x$3 -o x = x$4 -o x = x$5 ]; then
    echo "Usage: ./deploy_template.sh "
    echo "           <server>"
    echo "           <tenant>"
    echo "           <user>"
    echo "           <password>"
    echo "           <service>"
    exit
fi

SERVER=$1
TENANT=$2
USER=$3
PASSWORD=$4
SERVICE=$5
NETWORK_ID=$6
SITE_GROUP_ID=$6

export TOKEN=`curl -s  -H "Content-type: application/json"  -X POST https://$SERVER:443/keystone/v2.0/tokens -d "{ \"auth\": { \"tenantName\": \"$TENANT\", \"passwordCredentials\": { \"username\": \"$USER\", \"password\": \"$PASSWORD\"}}}" | jq '.access.token.id' | tr -d '"'`
echo $TOKEN

sed -e "s/__NETWORK_ID__/$NETWORK_ID/g" -e "s/__SITE_GROUP_ID__/$SITE_GROUP_ID/g" < $SERVICE.tpl > $SERVICE.json
curl -X POST -H "X-Auth-Token: $TOKEN" https://$SERVER/gohan/v1.0/services -d @$SERVICE.json
