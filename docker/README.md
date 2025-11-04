# Building docker images


## Remote

Remote part of LLView, all the dependencies are installed (see :https://apps.fz-juelich.de/jsc/llview/docu/install/remote_install/). `crond` is launched as a daemon. Remote depends of the `slurm-docker-cluster`, it's launched by `slurmctld`.

```sh
docker build -t remote --network=host docker/Remote
```
## Server

Server part of LLView, all the dependencies are installed (see: https://apps.fz-juelich.de/jsc/llview/docu/install/server_install/).

```sh
docker build -t server --network=host docker/Server
```
## Web

Web part of llview, some minor modification are made to allow all users to access the `/data` in the web server, see the file `000-default.conf`.

```sh
docker build -t web_server --network=host docker/Web
```