#! /bin/bash


#generates the slurm shell scripts for varying jumps and varying game
wkdir="/Users/dhocker/projects/spr_reproducibility/jobs"

cat $wkdir/gamelist

for game in `cat $wkdir/gamelist`
do
  for jumps in 0 1 2 3 4 5
  do
    for seed in `seq 10`
    do
	cat spr_template.sh |sed "s/GAME/$game/g"|sed "s/JUMPS/$jumps/"|sed "s/SEED/$seed/" > ${game}/spr_${game}_j${jumps}_${seed}.sh
	#echo "${game}/spr_${game}_j${jumps}_${seed}.sh"
    done
  done
done

