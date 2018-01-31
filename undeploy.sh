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

if [ x = x$SERVER -o x = x$TENANT -o x = x$USER -o x = x$PASSWORD -o x = x$SERVICE_NAME -o x = x$SERVICE_TEMPLATE_ID -o x = x$NETWORK_ID -o x = x$SITE_GROUP_ID ]; then
    echo "Usage: ./deploy.sh with the following env variables beeing not empty"
    echo "           SERVER"
    echo "           TENANT"
    echo "           USER"
    echo "           PASSWORD"
    echo "           SERVICE_NAME"
    echo "           SERVICE_TEMPLATE_ID"
    echo "           NETWORK_ID"
    echo "           SITE_GROUP_ID"
    exit 1
fi

echo "SERVER=$SERVER"
echo "TENANT=$TENANT"
echo "USER=$USER"
echo "PASSWORD=$PASSWORD"
echo "SERVICE_NAME=$SERVICE_NAME"
echo "SERVICE_TEMPLATE_ID=$SERVICE_TEMPLATE_ID"
echo "NETWORK_ID=$NETWORK_ID"
echo "SITE_GROUP_ID=$SITE_GROUP_ID"

ls -l defs

export TOKEN=`curl -s  -H "Content-type: application/json"  -X POST https://$SERVER:443/keystone/v2.0/tokens -d "{ \"auth\": { \"tenantName\": \"$TENANT\", \"passwordCredentials\": { \"username\": \"$USER\", \"password\": \"$PASSWORD\"}}}" | jq '.access.token.id' | tr -d '"'`
echo "TOKEN=$TOKEN"

export SERVICE_ID=`./describe_service.sh $SERVER $TENANT $USER $PASSWORD $SITE_GROUP_ID $SERVICE_TEMPLATE_ID | jq '.services[0].id' | sed 's/\"//g'`

./delete_service.sh $SERVER $TENANT $USER $PASSWORD $SERVICE_ID
