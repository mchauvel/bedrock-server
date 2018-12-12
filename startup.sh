#!/bin/sh

cd /home/bedrock

if [ -f "bedrock_server" ]; then
   echo "Executing server"
   LD_LIBRARY_PATH=. ./bedrock_server
else
   echo "Server software not downloaded or unpacked!"
fi
