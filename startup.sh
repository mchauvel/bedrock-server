#!/bin/sh

cd /home/bedrock

if [ ! -f "server.properties" ]; then
   cp server.properties.default server.properties
fi

if [ ! -f "permissions.json" ]; then
   cp permissions.json.default permissions.json
fi

if [ ! -f "whitelist.json" ]; then
   cp whitelist.json.default whitelist.json
fi

if [ -f "bedrock_server" ]; then
   echo "Executing server"
   LD_LIBRARY_PATH=. ./bedrock_server
else
   echo "Server software not downloaded or unpacked!"
fi
