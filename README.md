# Proof of concept : LLView - Matthias Lapu

This project is a fork of : https://github.com/giovtorres/slurm-docker-cluster.

It uses LLView : https://apps.fz-juelich.de/jsc/llview/docu/.

The goal was to create a basic cluster, and install the julich tool named LLView made to gather metrics in a HPC environment.

**Made during my intership at CEA.**

## Requirements

## Arboresence explanation

```
.
├── 📁 docker
├── 📁 scripts
├── 📁 shared
├── 📁 slurm
├── Dockerfile
├── docker-entrypoint.sh
├── prometheus.yml
├── docker-compose.yml
└── README.md
```

---

### `./slurm`

This folder contains the slurm configurations of the cluster. (.ie `slurm.conf`, `slurmdbd.conf`, `cgroup.conf`).

TLDR of `slurm.conf` :
- Taskplugin is turned off, the mapping of the CPU is made in the docker compose, .ie c1 -> cpu1, c2 -> cpu2, c3 -> cpu3.
- PMIX is enabled
- There is only 1 partition : `compute`
- Nodename are c[1-3].
- 1 CPU per node, 1000 of `RealMemory`
- Accounting is made using slurmdbd

---

### `./scripts`

This directory contains various scripts that to automate the installation and setup of this project :


- **`create_user.sh`**:
  Creates multiple users and registers them with the SLURM cluster.

- **`slurmctld_cron_start.sh`** :
  Automates the commands required to start the Remote part of LLview.
  > *Note: In this project, `slurmctld` represents the Remote component.*

- **`launch_job.sh`**:
  Submits a simple job for each user.

- **`register_cluster.sh`**:
  Registers the cluster with the SLURM database (`slurmdbd`).

  > *Note: This script should only be run once when the project is first set up.*

- **`cleanup.sh`**:
  Cleans the folder that is shared with the remote and the server (`shared/remote_server`).
  Also cleans the server shared with the web server (`shared/server_web`).

- **`launch_prometheus_node_exporter.sh`**
  Launches the Prometheus daemon on the compute node (`c1`,`c2`,`c3`).

- **`rerun.sh`**: Launches all the script in a logic order. Should be launched after every `docker compose up` to easily deploy the solution. Follows this order :
  1. `cleaup.sh`
  2. `create_user.sh`
  3. `launch_prometheus_node_exporter.sh`
  4. `slurmctld_cron_start.sh`
  5. `server_start.sh`
  6. `launch_job.sh`

---

### `./shared`


```
shared/
├── 📁 compute
├── 📁 JURI
├── 📁 llview_install
├── 📁 remote_server
└── 📁 server_web
```
This directory contains all the folders that are mounted in the Docker compose

- `/compute`, is mounted in all the compute node. .ie `c1`,`c2`,`c3`. It's mounted as is, therefore, the location in the compute node is still
  `/shared/compute`. This location contains all the script that the users will be able to launch.
- `JURI`, it's a `git clone` of https://apps.fz-juelich.de/jsc/llview/docu/install/juri_install/ , no change were made in this folder.
  This file is mounted in the Apache web server as `/var/www/html`
- `/remote_server` is a shared file system between the remote part and the server part. It's analog to the `${LLVIEW_SHARED}` of the .llview_remote_rc.
- `/server_web` is a shared file system between the server part and the web part. It's analog to the `${LLVIEW_WEB_DATA}` of the .llview_server_rc. This folder contains a `/data`, this folder is mounted in the web server in `/var/www/html/data`. This is made to prevent the use of the step `transferreport`. This step makes an Rsync of the `/data` folder located in remote to the web server.
- `llview_install` is a git clone of LLView. The `configs` folder inside contains all the modifications made for this proof of concept to work.