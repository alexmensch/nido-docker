#!/bin/zsh

# Ignore QEMU for local build
touch qemu-arm-static
docker build --tag="alexmensch/nido" .
