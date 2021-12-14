These are instructions adapted from Shenglong to create a singularity container that can run torch code.  
The super short version: Singularity is like a virtual environment that has exactly reproducible computing environment. 
Running a singularity command opens up a little self-contained file system and computing environment for you to do stuff. 
Imagine that you are sshing into a little pretend computer somewhere and running a command; it's like that.
We are going to build one up, then interactively run a job on the cluster to test the spr code


- I have been keeping my singularity images in the same subfolder for easy finding: `/scratch/dh148/singularity`. Make one for yourself

```
user=dh148 #change this to your netid
cd /scratch/$user
mkdir -p  singularity
cd singularity 
```

- copy and unzip the singularity overlay image. This will be mounted on `/ext3` when you go into the singularity container.
```
cp /scratch/work/public/overlay-fs-ext3/overlay-10GB-400K.ext3.gz .
gunzip overlay-10GB-400K.ext3.gz
```

- Find the right singularity environment that will support pytorch and Cuda. It is `/scratch/work/public/singularity/cuda11.1-cudnn8-devel-ubuntu18.04.sif` for rotch
For tensorflow is it `/scratch/work/public/singularity/cuda11.0-cudnn8-devel-ubuntu18.04.sif`  (this might be outdated now)

- To setup conda environment, fist launch container interactively, download conda, and make a script to load it on starting the singularity environment. 
This is the basic structure of the command to start singularity:
```
singularity exec --overlay overlay-10GB-400K.ext3 /scratch/work/public/singularity/cuda11.1-cudnn8-devel-ubuntu18.04.sif /bin/bash
```

- Now inside the container, download and install miniconda into `/ext3/miniconda3`
``` 
wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
sh Miniconda3-latest-Linux-x86_64.sh -b -p /ext3/miniconda3
```

- Create a wrapper script with editors such as vi or emacs, called `/ext3/env.sh` 

``` 
#!/bin/bash
source /ext3/miniconda3/etc/profile.d/conda.sh
export PATH=/ext3/miniconda3/bin:$PATH
```

- To active base conda
`source /ext3/env.sh`

- To test, see if these commands point to files. If pip does NOT, then chat with me:
`which conda`
 `which python`
 `which pip`

- now let\'s install the files needed for the code: pytorch, str, atari-py, and the atari ROMS
```
conda install pytorch torchvision -c pytorch
export LC_ALL=C.UTF-8
export LANG=C.UTF-8

cd /scratch/$user
git clone https://github.com/mila-iqia/spr
cd spr
pip install -r requirements.txt

pip install atari-py
```
- Get the ROMS and an archiving tool to open them

``` 
wget http://www.atarimania.com/roms/Roms.rar
conda install -c conda-forge go-archiver
arc unarchive Roms.rar
python -m atari_py.import_roms Roms
```

- Now try and run the code. First exit the container, and rename it
```
exit
mv overlay-10GB-400K.ext3 spr.ext3
```

- Ok, now let\'s try running an interactive job on the cluster and opening up the singularity container. From there, we can try the spr code
 `srun --nodes=1 --ntasks-per-node=1 --time=8:00:00 --mem=20GB --gres=gpu /bin/bash `

- Once that is running, open up a new terminal on greene, and ssh onto that node. We will open up a singularity container from there
```
user=dh148
ovfile=/scratch/$user/singularity/spr.ext3
singfile=/scratch/work/public/singularity/cuda11.1-cudnn8-devel-ubuntu18.04.sif

singularity exec --nv   --overlay $ovfile:ro $singfile /bin/bash
```

- Once you are the container, try running the SPR code:
```
source /ext3/env.sh
cd /scratch/$user/spr
python -m scripts.run --public --game pong --momentum-tau 1. 
```

If you want to run a job as usual with the SLURM scheduler, then make a .sh script that calls your code from inside of a singularity command. Example: run-test.sh. 
Note that there is an option to keep the overlay as readonly. This has to be done in order to allow multiple processes to use the same overlay (i.e., to have many batch scripts use the same files). 
We will run a file, `torch-test.py`

``` 
#!/bin/env python

import torch

print(torch.__file__)
print(torch.__version__)

# How many GPUs are there?
print(torch.cuda.device_count())

# Get the name of the current GPU
print(torch.cuda.get_device_name(torch.cuda.current_device()))

# Is PyTorch using a GPU?
print(torch.cuda.is_available())
```

This is the SLURM batch script `torch-test.sh`:
```
#!/bin/bash

#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --time=1:00:00
#SBATCH --mem=2GB
#SBATCH --gres=gpu
#SBATCH --job-name=torch-test

user=dh148
module purge

ovfile=/scratch/$user/singularity/spr.ext3
singfile=/scratch/work/public/singularity/cuda11.1-cudnn8-devel-ubuntu18.04.sif

singularity exec --nv --overlay $ovfile:ro $singfile /bin/bash -c "source /ext3/env.sh; python torch-test.py"
 ```


