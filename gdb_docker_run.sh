#!/bin/sh
image=${1:-gdb_docker}
docker run -it --rm \
  --cap-add=SYS_PTRACE \
  --security-opt seccomp=unconfined \
  ${image} bash
