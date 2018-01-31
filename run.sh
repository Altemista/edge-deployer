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

if [ x = x$COMMAND  ]; then
    echo "Usage: ./run.sh with the following env variables beeing not empty"
    echo "           COMMAND"
    exit 1
fi

echo "COMMAND=$COMMAND"

./$COMMAND
