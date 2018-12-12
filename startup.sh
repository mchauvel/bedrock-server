#!/bin/sh

cd /home/bedrock/bedrock_server

if [ ! -f "server.properties" ]; then
   mv server.properties.default server.properties
fi

if [ -f "bedrock_server" ]; then
   echo "Executing server"
   LD_LIBRARY_PATH=. ./bedrock_server
else
   echo "Server software not downloaded or unpacked!"
fi
