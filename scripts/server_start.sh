#!/bin/bash
# Automate the Server part of LLView
# https://apps.fz-juelich.de/jsc/llview/docu/install/server_install/
# Uses the Server img of docker, thus all the dependencies are already met
# for the img location, see ../docker/Server/Dockerfile
# /!\ -> /shared/llview_install/LLview is mounted as /Server in the docker compose
# Author : Matthias LAPU (CEA)

set -euo pipefail

CONTAINER="server"
SRC_FILE="/Server/configs/server/.llview_server_rc"
DEST_DIR="~/"
ACCOUNTMAP_FILE="/Server/accountmap.xml"
LLVIEW_DATA="/data"
LLVIEW_SYSTEMNAME="system"
CRONTAB_FILE="/Server/LLView/da/workflows/server/crontab/crontab.add"
UPDATEDB_SCRIPT="/Server/LLView/scripts/updatedb"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

echo "---------------Server-------------------"

log "Copying .llview_server_rc"
docker exec $CONTAINER bash -c "cp $SRC_FILE $DEST_DIR"
log "Copy .llview_server_rc DONE"

log "Coying the accountmap"
docker exec $CONTAINER bash -c "mkdir -p  $LLVIEW_DATA/$LLVIEW_SYSTEMNAME/perm/wservice "
docker exec $CONTAINER bash -c "cp $ACCOUNTMAP_FILE $LLVIEW_DATA/$LLVIEW_SYSTEMNAME/perm/wservice/accountmap.xml"
log "Copy of the accountmap DONE"

log "Creating the database using LLview updatedb script"
docker exec $CONTAINER bash -c "source ~/.llview_server_rc && $UPDATEDB_SCRIPT"
log "Database creation DONE"

log "Launching Crontab..."
docker exec "$CONTAINER" bash -c "crontab $CRONTAB_FILE"
log "Crontab started."

log "All tasks completed successfully."