#!/bin/bash  
#
# Run using: sbatch batch.sh
# 
# See options: http://research-it.berkeley.edu/services/high-performance-computing/user-guide/savio-user-guide
# See SBATCH documentation: http://research-it.berkeley.edu/services/high-performance-computing/running-your-jobs 
# 
# Job name:
#SBATCH --job-name=batch.sh
#
# Account:
#SBATCH --account=fc_cboettig
#
# Partition:
# savio_bigmem: 512 GB mem, savio: 64 GB
#SBATCH --partition=savio_bigmem
#
# QoS:
#SBATCH --qos=savio_normal
#
# Request one node: (since no MPI)
#SBATCH --nodes=1
#
# Specify number of tasks for use case (max 20, see docs):
#SBATCH --ntasks-per-node=24
#
# Processors per task:
#SBATCH --cpus-per-task=1
#
# Wall clock limit:
#SBATCH --time=72:00:00

## Command(s) to run:
singularity exec labnotebook.img R -f run.R
