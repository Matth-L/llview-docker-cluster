# Scripts

Multiple scripts are used to make this project more simple to launch :

- **`create_user.sh`**:
  Creates multiple users and registers them with the SLURM cluster.

- **`slurmctld_cron_start.sh`** :
  Automates the commands required to start the Remote part of LLview.
  > *Note: In this project, `slurmctld` represents the Remote component.*

- **`launch_job.sh`**:
  Submits a simple job for each user. This job is located in `shared/compute/`.

- **`register_cluster.sh`**:
  Registers the cluster with the SLURM database (`slurmdbd`).
  > *Note: This script should only be run once when the project is first set up.*

- **`cleanup.sh`**:
  Cleans the folder that is shared with the remote and the server (`shared/remote_server`).
  Also cleans the server shared with the web server (`shared/server_web`).

- **`launch_prometheus_node_exporter.sh`**
  Launches the Prometheus daemon on the compute node (`c1`,`c2`,`c3`).

- **`rerun.sh`**: Launches all the script in a logic order. Should be launched after every `docker compose up` to easily deploy the solution. `rerun.sh` follows this order :
  1. `cleaup.sh`
  2. `create_user.sh`
  3. `launch_prometheus_node_exporter.sh`
  4. `slurmctld_cron_start.sh`
  5. `server_start.sh`
  6. `launch_job.sh`
