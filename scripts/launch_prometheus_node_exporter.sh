#!/bin/bash
# Launches prometheus on each compute node,
# the path is not generic and is related to the ./Dockerfile that is the *
# `slurm-docker-cluster` img
# Author : Matthias LAPU (CEA)

set -euo pipefail

NODELIST=("c1" "c2" "c3")

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

for compute_node in "${NODELIST[@]}"; do
    log "Launching prometheus node_exporter for $compute_node"
    docker exec $compute_node bash -c \
    "./node_exporter-1.9.1.linux-amd64/node_exporter --collector.cpu.info &"
done