#!/bin/bash
# This script cleans up the shared filesystem between the remote and the server
# It also cleans the shared file system betweend the web server and the server
# Running this script is optionnal, but it's great to have everything fresh
# Author : Matthias LAPU (CEA)

set -euo pipefail

REMOTE="slurmctld"
WEB_SERVER="web_server"

# Cleaning the shared filesystem between the remote and the server.
echo "Cleaning Remote <------> Server shared"
docker exec $REMOTE bash -c "rm -rf /shared/remote_server/*"

# Cleaning the shared filesystem between the server and apache server.
echo "Cleaning Server <------> Web shared"
docker exec $WEB_SERVER bash -c "rm -rf /var/www/html/data/*"


echo "Clean up DONE."