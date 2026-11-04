#!/bin/sh
# Start the Node.js server in the background
node .output/server/index.mjs &

# Start nginx in the foreground
nginx -g 'daemon off;'
