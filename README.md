# spr_reproducibility
project: reproducing results of self-predictive representation by Schwarter et al. 2017
(https://arxiv.org/pdf/2007.05929v4.pdf

after pulling the repo it would be good to make a branch for yourself and check in frequently with the master branch

cheatsheet for working with branches

to create or switch to a branch
git checkout [branch name] 

to see which branch I am in
git branch

to delete a branch
git branch -d [branch name]

to see all branches created
git branch -a


[Running log of issues](https://docs.google.com/document/d/17vGnCX7yZR3KKBifrHasRHKHJLIPusClNHFhkvShqyQ/edit) we noticed with the original code

## basic directory structure

- `spr/`: original code we are trying to recreate
- `src/`: where our core code lives
- `jobs/`: hpc job files, including SLURM scripts
- `studies/`:notebooks and python code to try out ideas. The buildup code to full demos or code we want to present to run stuff.
- `vis/`: important visualization code
- `utils/`: extra code without a good place to go. includes instructions for singularity setup

