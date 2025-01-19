#!/bin/bash

sudo podman build \
  --security-opt=label=disable \
  --cap-add=all \
  --device /dev/fuse -t tier-0:"$(date +%s)" -t tier-0:latest \
  --build-arg=MANIFEST=fedora-tier-0.yaml \
  .
