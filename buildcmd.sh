#!/bin/env bash

podman build \
  --from quay.io/fedora/fedora:41 \
  --security-opt=label=disable \
  --cap-add=all \
  --device /dev/fuse -t localhost/fedora-bootc-hypervisor:41 \
  -t localhost/fedora-bootc-hypervisor:${1} \
  -t ghcr.io/bensmith/fedora-bootc-hypervisor:${1} \
  --build-arg=MANIFEST=hyper-bootc.yaml \
  .
