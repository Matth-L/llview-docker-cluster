#!/bin/bash
#SBATCH --nodes=1
#SBATCH --time=00:12:00

stress -c 1 --timeout 600 # 10min