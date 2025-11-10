# Proof of concept : LLView - Matthias Lapu

This project is a fork of : https://github.com/giovtorres/slurm-docker-cluster.

It uses LLView : https://apps.fz-juelich.de/jsc/llview/docu/.

The goal was to create a basic cluster, and install the julich tool named LLView made to gather metrics in a HPC environment.

**Made during my intership at CEA.**

# Quickstart

Building all the image (The build time is long) :
```sh
docker build -t slurm-docker-cluster --network=host .
docker build -t remote --network=host ./docker/Remote
docker build -t server --network=host ./docker/Server
docker build -t web_server --network=host ./docker/Web
```

> /!\ Manual step for now, go to `shared/LLView/da/rms/Prometheus/prometheus.py` and change `https` to `http` line 230 and 233.

```sh
docker compose up -d
./scripts/register_cluster.sh
./scripts/rerun.sh
```

LLView is available here : http://localhost:8080. (Wait a bit for the data to fill the server web, when `/shared/server_web/data` starts to fill access the website).

# How everything works

## Main Dockerfile & Docker-compose

This project uses docker as a way to create the cluster. The main image with slurm, pmix, openmpi and so on is located at the base of this project (`./Dockerfile`), it's named `slurm-docker-cluster`. At the end of the build `docker-entrypoint.sh` is copied.

The cluster is launched using `docker-compose`.

To build the main image :

```sh
docker build -t slurm-docker-cluster --network=host .
```

## Prometheus

Prometheus is also used in this project, the configuration is minimal and located in `./prometheus.yaml`. A static configuration is used because all the nodes are available in the network, therefore it's easier to access them.

All the node in the cluster (`c1,c2,c3,slurmctld`) have `node-exporter` installed, it's the last step of the `slurm-docker-cluster` img.

## Arborescence explanation

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

### `./docker`

TLDR : This directory contains the remote, server and web server part of LLView.
Disclaimer  : To build the image, `--network=host` is used but is completely optionnal.

```sh
docker build -t remote --network=host docker/Remote
docker build -t server --network=host docker/Server
docker build -t web_server --network=host docker/Web
```

[for more info, click here](./docker/README.md)

---

### `./scripts`

This directory contains various scripts that to automate the installation and setup of this project.

[for more info, click here](./scripts/README.md)

---

### `./shared`

This directory contains all the folders that are mounted in the `docker-compose.yml`.

```
shared/
├── 📁 compute
├── 📁 JURI
├── 📁 llview_install
├── 📁 remote_server
└── 📁 server_web
```

[for more info, click here](./shared/README.md)

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

