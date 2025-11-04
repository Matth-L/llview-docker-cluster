#!/bin/bash
#SBATCH --nodes=1
#SBATCH --time=00:12:00

stress -c 1 --vm 20 --vm-bytes 128M --timeout 600 # 10min