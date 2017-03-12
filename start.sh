#!/bin/sh -ex
cd $SERVER
./update.sh

exec ./server.sh "$@"
