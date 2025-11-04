#!/bin/bash
# Automate the Remote part of LLView
# https://apps.fz-juelich.de/jsc/llview/docu/install/remote_install/
# Uses the Remote img of docker, thus all the dependencies are already met
# for the img location, see ../docker/Remote/Dockerfile
# Author : Matthias LAPU (CEA)

set -euo pipefail

CONTAINER="slurmctld"
SRC_FILE="/Remote/configs/remote/.llview_remote_rc"
DEST_DIR="~/"
CRONTAB_FILE="/Remote/LLView/da/workflows/remote/crontab/crontab.add"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

echo "---------------Remote-------------------"

log "Copying llview_remote_rc (source file)"
docker exec "$CONTAINER" bash -c "cp $SRC_FILE $DEST_DIR"
log "File copied successfully."

log "Starting crond service"
docker exec "$CONTAINER" bash -c "crond"
log "crond started."

log "Launching Crontab..."
docker exec "$CONTAINER" bash -c "crontab $CRONTAB_FILE"
log "Crontab started."

log "All tasks completed successfully."