#!/bin/bash

#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --time=8:00:00
#SBATCH --mem=12GB
#SBATCH --job-name=spr_GAME_jJUMPS_SEED
#SBATCH --mail-type=END
#SBATCH --mail-user=dh148@nyu.edu
#SBATCH --gres=gpu

module purge

user=dh148

#which overlay and singularity containers are used
ovfile=/scratch/dh148/singularity/spr.ext3
singfile=/scratch/work/public/singularity/cuda11.0-cudnn8-devel-ubuntu18.04.sif

#what is yoru conda environment
condaenv=/ext3/env.sh

#what specific command are you running
wkdir=/scratch/$user/spr_reproducibility/spr/
cd $wkdir
seed=SEED
game=GAME
jumps=JUMPS
fname=${game}_j${jumps}_${seed}
export WANDB_ENTITY="spr_reproducibility"

cmd="python -u -m scripts.run --public --game $game --jumps $jumps --seed $seed --momentum-tau 1. --wandb_name $fname"

#run the singularity bash command
singularity exec --nv \
	    --overlay $ovfile:ro $singfile /bin/bash -c "source $condaenv; $cmd"

echo "done"



