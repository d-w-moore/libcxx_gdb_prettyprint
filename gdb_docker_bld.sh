#!/bin/sh
image=${1:-gdb_docker}
docker build -t ${image} .
