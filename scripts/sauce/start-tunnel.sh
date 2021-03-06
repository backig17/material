#!/bin/bash

SAUCE_BINARY_FILE="sc-latest-linux.tar.gz"
SAUCE_BINARY_DIR="/tmp/sauce"
SAUCE_ACCESS_KEY=`echo $SAUCE_ACCESS_KEY | rev`
SAUCE_READY_FILE="/tmp/sauce-readyfile"

echo "Installing Sauce Connector binaries..."

mkdir -p $SAUCE_BINARY_DIR

# Install the Sauce Connector binary
wget https://saucelabs.com/downloads/$SAUCE_BINARY_FILE -O $SAUCE_BINARY_DIR/$SAUCE_BINARY_FILE
tar -xzf $SAUCE_BINARY_DIR/$SAUCE_BINARY_FILE -C $SAUCE_BINARY_DIR --strip-components=1

# Arguments to be applied to the Sauce Connector.
CONNECT_ARGS="--readyfile $SAUCE_READY_FILE"

# Apply the Travis Job Number to the tunnel
if [ ! -z "$TRAVIS_JOB_NUMBER" ]; then
  CONNECT_ARGS="$CONNECT_ARGS --tunnel-identifier $TRAVIS_JOB_NUMBER"
fi

echo "Starting Sauce Connector Tunnel"
echo "- Username: $SAUCE_USERNAME"
echo "- Arguments: $CONNECT_ARGS"

# Starting the Sauce Tunnel.
$SAUCE_BINARY_DIR/bin/sc -u $SAUCE_USERNAME -k $SAUCE_ACCESS_KEY $CONNECT_ARGS &

# Wait for the tunnel to be ready.
while [ ! -e $SAUCE_READY_FILE ]; do sleep 1; done

echo "Sauce Tunnel is now ready"