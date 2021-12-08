#!/bin/bash

#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --time=1:00:00
#SBATCH --mem=2GB
#SBATCH --gres=gpu
#SBATCH --job-name=torch-test

module purge
user=dh148

ovfile=/scratch/$user/singularity/spr.ext3
singfile=/scratch/work/public/singularity/cuda11.1-cudnn8-devel-ubuntu18.04.sif

singularity exec --nv --overlay $ovfile:ro $singfile /bin/bash -c "source /ext3/env.sh; python torch-test.py"
