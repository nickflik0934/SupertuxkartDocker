#!/bin/sh

# Start server
echo "Starting supertuxkart server!"
./supertuxkart --server-config=config.xml

# Return to console
exec "$@"
