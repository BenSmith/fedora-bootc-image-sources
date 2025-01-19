#!/bin/bash

podman build \
  --build-arg=MANIFEST=fedora-tier-0.yaml \
  --cap-add=all \
  --device /dev/fuse \
  --security-opt=label=disable \
  -t tier-0:"$(date +%s)" \
  -t tier-0:latest \
  .
